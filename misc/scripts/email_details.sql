declare
    identifier CB_BILLCYCLE_RELEASE_ENTITIES.identifier_n%TYPE;
    recipient_info CB_BILLCYCLE_RELEASE_ENTITIES.RECIPIENT_INFO_V%TYPE;
    subscriber_category CB_ACCOUNT_MASTER.SUBSCRIBER_CATEGORY_V%TYPE;

    type table_varchar is table of varchar2(50);
    email_list table_varchar;

begin
    email_list := table_varchar(
	'joelnicco.ann',
'info@oasiacap',
'decorplastlim',
'architecture@',
'munirhabash@g',
'nabdick@yahoo',
'memhayatint@g',
'ernestdarkwah',
'srighan@yahoo',
'ghveritas@ver',
'debra.jane@th',
'salinkam@yaho',
'raintillsepte',
'simliradio@ya',
'natjo200@yaho',
'ndutilleul@cf',
'admin@provisi',
'joemaycar_ren',
'ckboamah@yaho',
'emefa@mgcbed.',
'trtlvwest@gma',
'magico.coltd@',
'itmanager@izw',
'it@multi-tech',
'ernest.hammon',
'barrymoree@me',
'augustin_hui@',
'JDADZIE@CARME',
'FTURKSON@GHAM',
'info@koalasho',
'nat.tettey@se',
'e.acquach@gol',
'ssowah@paloma',
'JOHN.MENYA@OT',
'ssowah@paloma',
'rabi@wrangler',
'yousef.ebadi@',
'eunice_krampa',
'nicholas@minp',
'marketing@nex',
'afrodan@ighma',
'plasterboard@',
'aafriyie70@ya',
'ghanaoff@ever',
'fvorgbe@fkvgh',
'odeliyee@gmai',
'embrscoco@yah',
'ARDERTGH@YAHO',
'info@mgsystem',
'AHANTAMANRURA',
'agnes.akyeamp',
'GHANAFIN@MAXA',
'angel@arytond',
'RH@vestergaar',
'irene@rockure',
'rthomas@flemi',
'cellemahor22@',
'sandep-in@yah',
'i.toure@the_f',
'alicesaanuo@y',
'metro.martins',
'fulvionidoni@',
'fgyabaah@fedc',
'thealfmeggrou',
'a.hassan@gold',
'praycash@vvkw',
'nafaez@grafit',
'DESMONDA@TAKM',
'anthonyadabla',
'george.debrah',
'elie.adventur',
'foosammi@gmai',
'joelboahen@ya',
'adugyamfibrig',
'khzahra1986@h',
'amoakjulius@g',
'amoakjulius@g',
'amoakjulius@g',
'owusuansahthe',
'amoakjulius@g',
'sinantho20@gm',
'adowaninsin@y',
'amoakjulius@g',
'rbalyunam@yah',
'adinyiraf@yah',
'info@elnental',
'joe.anim@hotm',
'luuicsky@hotm',
'dharweegusin@',
'simonsaoud@te',
'ckhoueir@fore',
'benjyoiale@ya',
'amacorts1@gma',
'saachanso@yah',
'emmanuelmawud',
'kofibuaduamoa',
'arahaman@yaho',
'info@monicapi',
'macdeybie@hot',
'oatuu@ighmail',
'scoffies58@ya',
'izihakhili@gm',
'frankcool@yah',
'danilo@adobre',
'sleimanoream@',
'yawokyere.oke',
'samueladuana@',
'gracedeby@yah',
'info@furnitur',
'boateng-kwame',
'menzira.memdi',
'oyelarbie@nol',
'dorisyarney@y',
'infoatacmetra',
'dean7117@gmai',
'wordoffiremin',
'isaacboak83@y',
'wagbo19@hotma',
'i1takoradibra',
'niiarmahsammy',
'seidu.forster',
'eric2020@ymai',
'rndsnw@yahoo.',
'firstpapergha',
'gilbert@atlan',
'topzonecleani',
'charlesfandoh',
'yawnatekpor02',
'info@sunsofta',
'design.coolin',
'eugeniaofori@',
'tony.boctwe@w',
'fberkoe@yahoo',
'nellychis23@y',
'walidzoo@gmai',
'iraryee@yahoo',
'centralhotel@',
'sanderstercon',
'kofiaduamah@y',
'afflumorkor@g',
'happysoul@yah',
'AAAJEI2002@YA',
'kayanmatthew2',
'mannor@yahoo.',
'cecilia-fiaka',
'brcudjoe@chem',
'nofkanasah@ym',
'kobbygha@yaho',
'philip.addiso',
'benardturkson',
'irenekdotei@g',
'edmund.mnjgro',
'kwame@sunseek',
'alwan.hitti@g',
'ericnartey@is',
'matobengasong',
'comradike@yah',
'adjeistephen@',
'glostalalumin',
'alfreatt@yaho',
'samuel.w.amis',
'skpak23@yahoo',
'ascrown@afica',
'clifford.mett',
'leanbro.anipa',
'ekgyimah@yaho',
'mardea@yahoo.',
'ghddatme@yaho',
'spadamu_dib@y',
'anighatmotors',
'royalprotocol',
'danquah4@hotm',
'euniceappente',
'cquarmson@aur',
'locran2000@ya',
'teamwork@afri',
'info@afariwaa',
'Ladikpo@gmail',
'saidjewelry@y',
'professionala',
'kingsmanenter',
'williamgyane@',
'cofckans@yaho',
'JOHNDOKU75@YA',
'ciciliadekyi@',
'huerkof_2006@',
'electrinash@y',
'yamtech@myzip',
'tweneboahyaw2',
'patricia.djan',
'pawoonor@hotm',
'gasiamah@fugo',
'mawukosowu_4@',
'mogoro2020@ya',
'sobsrajagtian',
'lizberty_koom',
'p_abritt@ghan',
'soseibonsu22@',
'elvisboamah@a',
'yipchun@yahoo',
'xchall110@hot',
'maamenancy@ho',
'samuelntimboa',
'georgiamortad',
'admin@kiccgha',
'asroc@asrocgh',
'kas.multiferr',
'lomenss@yahoo',
'hayssam@fants',
'shalomtexgh@y',
'florence@west',
'SOSGHANA@SOSG',
'haicefordinte',
'simbinfurnitu',
'rmbaum@gmx.de',
'laminiinvest@',
'mandahjas@yah',
'etapietu@yaho',
'treasure.ghan',
'santoshkumar.',
'elbaelba6117@',
'Kingsford.Baa',
'ali.ayach@mtn',
'augustus.ameg',
'khaliljichi@y',
'biritwum@afri',
'sundayekae@ya',
'rafeeqsula@gm',
'danny@c-tech.',
'terpomaagro@y',
'noreen_narwan',
'ohayo@myzipne',
'macdonaldoran',
'qipnkp18@yaho',
'aquasafewater',
'flofeena@yaho',
'awossado@hotm',
'genegroup@yah',
'a4amagetby@ya',
'daasebre4000@',
'adoucatal_141',
'naaseamodex@g',
'selase@e-newo',
'lohemkfranzy@',
'nana-esiabaha',
'ram-venkat@sh',
'atibumpare@ho',
'patrickkwadzi',
'tinickis@yaho',
'ebenaebzii@ya',
'gladys@eastca',
'syvie2g@hotma',
'paul.minlah@d',
'richcapane45@',
'charlie@gmail',
'ittijh@gmail.',
'aisha.obuobo@',
'kevin_sifoods',
'jobifrimp@yah',
'handsomemayan',
'benfoma2005@y',
'g_gopaldas@th',
'LIVINGSTONESA',
'naatechiwaa@h',
'Kyankyera@kin',
'wiiddrisu@gma',
'hermani.bani@',
'ernestpublica',
'hhammond@oic.',
'kboateng@chic',
'alexasante@gh',
'kanggau.hr@gm',
'pwusuansahr@m',
'zukazk@yahoo.',
'p.frimpong@gr',
'rkwarfo@hotma',
'aguadzemichea',
'fooco@yahoo.c',
'aankrah@yahoo',
'dagyemang@gsr',
'kwasiamo67@ya',
'kez@millionai',
'mgriffen@ghan',
'kakraduffour@',
'rev-ernest@ya',
'tma.aquaicoe@',
'pkyei@wildwin',
'provincial@sd',
'egyebidonkor@',
'haboakyi@yaho',
'dan@bigishafr',
'nytwum@gmail.',
'kwenyam@hotma',
'moses.doyem19',
'ha.abubukari@',
'costyonline@h',
'kotoo@ghanapo',
'sethoawauh@ya',
'koussa_micke@',
'emmanuel@king',
'ave_michel@ho',
'Theosupermari',
'vdzator@yahoo',
'kwaashley@yah',
'kyenyam@yahoo',
'sylvanuskoue@',
'sayed.ghajar@',
'kwame.danquah',
'ramiak6@hotma',
'aefoebessah@y',
'clement@yahoo',
'pltsspss@yaho',
'matildamintah',
'sekyereab@hot',
'gifty@jonmoor',
'rbaluman@yaho',
'cbosafo@yahoo',
'kricketts@sas',
'samjonfiah@ya',
'marisiama@yah',
'clement@engin',
'aquinesq@hotm',
'sosghana@sosg',
'oforiatta@yah',
'kans@yahoo.co',
'mnwini@yahoo.',
'micheal.agbem',
'gmayer@sdbafw',
'contruzioni.t',
'info@purcghan',
'edeidei@hotma',
'james.lambong',
'768537380@99.',
'768537380@99.',
'c.okpoti9@gma',
'bernard.twum-',
'cfrimpong@g5.',
'colin@tropica',
'ghanahomes@mu',
'ekuarj76@hotm',
'aboateng@3sil',
'aboateng@3sil',
'benuniwel@gma',
'benuniwel@gma',
'yowusu-akyaw@',
'ofaosakyid@gm',
'lloydashiley@',
'cute_gigi688@',
'sundagh.marke',
'ceo.ghanadist',
'lindedrah45@y',
'mathias@yahoo',
'dokai36@yahoo',
'okleyghana@ya',
'pol.song@yaho',
'kotangilo@yah',
'sethwotordzor',
'esunmadealeye',
'harrisondaman',
'banyamekye@ya',
'dxt700@yahoo.',
'steporal@yaho',
'drkudus@yahoo',
'cudgamas@yaho',
'addisu.evans@',
'fireteechlik@',
'micheal.asare',
'georgeotengsa',
'oblitey@yahoo',
'niimanlee@yah',
'yarsser2030gh',
'sheilaannan@y',
'kwamentisarpo',
'perryoffei@ya',
'merlvyn@yahoo',
'maxtraltd@yah',
'bako2016@yaho',
'nyameak@yahoo',
'ekwatelai@yah',
'crystalhomesi',
'pearl.botchwa',
'pearl.botchwa',
'jhnsonderrick',
'enramanatha@g',
'order@jofelca',
'ypaansah@yaho',
'christie@mesh',
'jude.jarthur@',
'skumatia@yaho',
'uchekrist@yah',
'duby-love90@y',
'derrickchrist',
'landa.partner',
'hungrysolutio',
'thelinecompan',
'info@kingdomh',
'aeyioo@gmail.',
'tabire.asumad',
'accounts@mtsw',
'akudzeto@ghan',
'kobinaamoah@h',
'jsyorke@yahoo',
'teggyoseitutu',
'mawuenaadevoe',
'jagtaini_anil',
'peabo@bluewin',
'ritamylove@ya',
'kwameonasis@g',
'aosumadu@yaho',
'goshen@intern',
'djkniitse@yah',
'eddieadm@yaho',
'ericad2000@ya',
'adel@forwingh',
'alsiejohnny@g',
'albertquaye@y',
'rebert.friese',
'alarbi@cfao.c',
'zacequa@yahoo',
'prosper-akpem',
'skumatsia@yah',
'a_gatcher@yah',
'amandasum30@y',
'jkboakye@yaho',
'fgolloah@yaho',
'delali@yahoo.',
'samuelkyamela',
'archidor@yaho',
'benuniwel@gma',
'aboateng@3sil',
'ameayoe45@yah',
'anthony.amuah',
'wumzalgu2004@'
    );
	
	for i in 1 .. email_list.count
	loop
		
		insert into tmp_email_details
			SELECT A.IDENTIFIER_N, A.RECIPIENT_INFO_V, B.SUBSCRIBER_CATEGORY_V 
			FROM CB_BILLCYCLE_RELEASE_ENTITIES A, CB_ACCOUNT_MASTER B 
			WHERE REF_NUM_N=235 AND PROCESS_ID_N=5
			AND UPPER(RECIPIENT_INFO_V) 
			LIKE UPPER('%' || email_list(i) || '%')
			AND A.IDENTIFIER_N=B.ACCOUNT_CODE_N;
		
	end loop;
end;

truncate table tmp_email_nov_1;
commit;