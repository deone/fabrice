

import java.util.*;
import java.io.*;

import java.security.*;
import javax.crypto.*;
import javax.crypto.spec.*;



/**
 * @author PrashanthM
 * @date Jul 4, 2006
 */
public class PasswordEncryption {
	/**
	 * Comment for <code>KEY_STRING</code>
	 */
	private static final String	KEY_STRING	= "0-1-12-15-8-9-12-4";

	/**
	 * @class PasswordEncryption
	 * @method encrypt
	 * @param source
	 * @return
	 */
	public static String encrypt(String source) {
		try {
			Key key = getKey();
			Cipher desCipher = Cipher.getInstance("DES/ECB/PKCS5Padding");
			desCipher.init(Cipher.ENCRYPT_MODE, key);
			byte[] cleartext = source.getBytes();
			byte[] ciphertext = desCipher.doFinal(cleartext);
			return getString(ciphertext);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * @class PasswordEncryption
	 * @method generateKey
	 * @return
	 */
	public static String generateKey() {
		try {
			KeyGenerator keygen = KeyGenerator.getInstance("DES");
            
            
			SecretKey desKey = keygen.generateKey();
			byte[] bytes = desKey.getEncoded();
			return getString(bytes);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * @class PasswordEncryption
	 * @method decrypt
	 * @param source
	 * @return
	 */
	public static String decrypt(String source) {
		try {
			// Get our secret key
			Key key = getKey();
			Cipher desCipher = Cipher.getInstance("DES/ECB/PKCS5Padding");
			byte[] ciphertext = getBytes(source);
			desCipher.init(Cipher.DECRYPT_MODE, key);
			byte[] cleartext = desCipher.doFinal(ciphertext);
			return new String(cleartext);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * @class PasswordEncryption
	 * @method getKey
	 * @return
	 */
	private static Key getKey() {
		try {
			byte[] bytes = getBytes(KEY_STRING);
			DESKeySpec pass = new DESKeySpec(bytes);
			SecretKeyFactory skf = SecretKeyFactory.getInstance("DES");
			SecretKey s = skf.generateSecret(pass);
            
			return s;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	
	/**
	 * @class PasswordEncryption
	 * @method isEncrypted
	 * @param text
	 * @return
	 */
	public static boolean isEncrypted(String text) {
		if (text.indexOf('-') == -1) {
			return false;
		}

		StringTokenizer st = new StringTokenizer(text, "-", false);
		while (st.hasMoreTokens()) {
			String token = st.nextToken();
			if (token.length() > 3) {
				return false;
			}
			for (int i = 0; i < token.length(); i++) {
				if (!Character.isDigit(token.charAt(i))) {
					return false;
				}
			}
		}
		return true;
	}

	/**
	 * @class PasswordEncryption
	 * @method getString
	 * @param bytes
	 * @return
	 */
	private static String getString(byte[] bytes) {
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < bytes.length; i++) {
			byte b = bytes[i];
			sb.append((int) (0x00FF & b));
			if (i + 1 < bytes.length) {
				sb.append("-");
			}
		}
		return sb.toString();
	}

	/**
	 * @class PasswordEncryption
	 * @method getBytes
	 * @param str
	 * @return
	 */
	private static byte[] getBytes(String str) {
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		StringTokenizer st = new StringTokenizer(str, "-", false);
		while (st.hasMoreTokens()) {
			int i = Integer.parseInt(st.nextToken());
			bos.write((byte) i);
		}
		return bos.toByteArray();
	}

	/**
	 * @class PasswordEncryption
	 * @method showProviders
	 * 
	 */
	public static void showProviders() {
		try {
			Provider[] providers = Security.getProviders();
			for (int i = 0; i < providers.length; i++) {
				for (Iterator itr = providers[i].keySet().iterator(); itr.hasNext();) {
					String key = (String) itr.next();
					String value = (String) providers[i].get(key);

				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * @class PasswordEncryption
	 * @method getPassword
	 * @return
	 */
	/*public static String getPassword() {

		Random ran = new Random();
		String passKey = String.valueOf(ran.nextInt());
		passKey = passKey.substring(1,9);
		return passKey;

	}*/
	
	public static String getPassword() {

		Random ran = new Random();
		String passKey = String.valueOf(ran.nextInt());
        int end = passKey.length();
        for(int i=0;i<=9-end;i++)
        {
            passKey = passKey + String.valueOf(ran.nextInt(1000)).substring(0,1);
        }
		passKey = passKey.substring(1,9);
		return passKey;
		
		//return "password123";

	}
    
    public static String getPassword_CHOWNER() {

		Random ran = new Random();
        //ran.setSeed(10);
		String passKey = String.valueOf(ran.nextInt());
		passKey = passKey.substring(1,5);
		return passKey;

	}
    
    public static void main(String[] args) {
    	//2013 12:00:00" END_DATE="06/02/2013 12:00:00" CARD_ACC_HOLDER_NAME="Santosh Kulal" BANK_REASON="DD03" CARD_TYPE="MCARS" CARD_NUMBER="1234567890" CVV_NUMBER="99-34-20
    	//0-23-213-156-126-105" CIN_NUMBER="" BANK_CODE="120100" CARD_EXPIRY_DATE="09/01/2014 12:00:00" BRANCH_CODE="" NEGOTIATING_BANK="120100" AUTO_DEBIT_REMARKS="test" ACCO
    	
		System.out.println("EN_MBAOD"+" "+decrypt("252-64-1-238-67-210-199-109-193-2-66-31-197-84-157-120"));
		System.out.println("TE_BASSA"+ " "+decrypt("19-32-163-178-94-189-119-194-193-2-66-31-197-84-157-120"));
		//System.out.println("FDODD"+ " "+decrypt("12-23-123-193-243-97-46-151-193-2-66-31-197-84-157-120"));
		//System.out.println("GBEDIAKO"+ " "+decrypt("94-129-41-255-240-207-232-169-193-2-66-31-197-84-157-120"));
		//System.out.println("HANUM"+ " "+decrypt("29-137-126-63-92-165-30-234-193-2-66-31-197-84-157-120"));
		//System.out.println("MAGBOMLA"+ " "+decrypt("57-41-28-233-209-178-191-182-193-2-66-31-197-84-157-120"));
		//System.out.println("MAYAHAYA"+ " "+decrypt("146-111-70-171-220-90-49-182-193-2-66-31-197-84-157-120"));
		//System.out.println("MVANDER"+ " "+decrypt("72-33-35-63-15-2-176-193-193-2-66-31-197-84-157-120"));
		//System.out.println("VNARH"+ " "+decrypt("246-116-33-36-120-152-118-248-193-2-66-31-197-84-157-120"));
		//System.out.println("USAAJO"+ " "+decrypt("99-38-140-80-13-34-230-100-193-2-66-31-197-84-157-120"));
		//System.out.println("YADAM"+ " "+decrypt("3-113-168-232-149-62-198-75-193-2-66-31-197-84-157-120"));
		//System.out.println("YKALI"+ " "+decrypt("237-59-99-176-241-117-13-206-193-2-66-31-197-84-157-120"));
		
	}
}