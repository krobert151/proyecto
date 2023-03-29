DROP TABLE IF EXISTS usuario CASCADE ;
DROP TABLE IF EXISTS administrador CASCADE ;
DROP TABLE IF EXISTS cliente CASCADE ;
DROP TABLE IF EXISTS producto CASCADE ;
DROP TABLE IF EXISTS lineaVenta CASCADE ;
DROP TABLE IF EXISTS venta CASCADE ;
DROP TABLE IF EXISTS encuentro CASCADE ;
DROP TABLE IF EXISTS especie CASCADE ;
DROP TABLE IF EXISTS genero CASCADE ;
DROP TABLE IF EXISTS familia CASCADE ;
DROP TABLE IF EXISTS orden CASCADE ;
DROP TABLE IF EXISTS clase CASCADE ;
DROP TABLE IF EXISTS filo CASCADE ;
DROP TABLE IF EXISTS reino CASCADE ;

CREATE TABLE usuario(
	id_usuario 			serial,
	nombre				varchar(50) NOT NULL,
	apellidos 			varchar(50) NOT NULL,
	correo				varchar(256) NOT NULL,
	username 			varchar(16) UNIQUE,
	passwd 				varchar(16) NOT NULL,
	fechaNac			date NOT NULL,
	CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
	CONSTRAINT mail CHECK (correo ILIKE '%@%' ),
	CONSTRAINT st_passwd CHECK (passwd ~ '^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+])')
);

CREATE TABLE cliente(
	id_usuario 			serial,
	CONSTRAINT pk_cliente PRIMARY KEY (id_usuario)
)INHERITS (usuario);

CREATE TABLE administrador(
	id_usuario 			serial,
	dni 				varchar(9) NOT NULL,
	CONSTRAINT pk_administrador PRIMARY KEY (id_usuario),
	CONSTRAINT dni_ck CHECK (dni ~ '^[0-9]{8}$' )
)INHERITS (usuario);

CREATE TABLE reino(
	nombre 				varchar(50),
	descripcion 		TEXT NOT NULL,
	CONSTRAINT pk_reino PRIMARY KEY (nombre)
);

CREATE TABLE filo(
	nombre 				varchar(50),
	descripcion 		TEXT NOT NULL,
	reino 				varchar(50),
	CONSTRAINT pk_filo PRIMARY KEY (nombre)
);

CREATE TABLE clase(
	nombre 				varchar(50),
	descripcion 		TEXT NOT NULL,
	filo 				varchar(50),
	CONSTRAINT pk_clase PRIMARY KEY (nombre)
);

CREATE TABLE orden(
	nombre 				varchar(50),
	descripcion 		TEXT NOT NULL,
	clase 				varchar(50),
	CONSTRAINT pk_orden PRIMARY KEY (nombre)
);

CREATE TABLE familia(
	nombre 				varchar(50),
	descripcion 		TEXT NOT NULL,
	orden 				varchar(50),
	CONSTRAINT pk_familia PRIMARY KEY (nombre)
);

CREATE TABLE genero(
	nombre 				varchar(50),
	descripcion 		TEXT NOT NULL,
	familia 				varchar(50),
	CONSTRAINT pk_genero PRIMARY KEY (nombre)
);

CREATE TABLE especie(
	nombre 				varchar(50),
	descripcion 		TEXT NOT NULL,
	genero 				varchar(50),
	CONSTRAINT pk_especie PRIMARY KEY (nombre)
);

CREATE TABLE encuentro (
	usuario 			int,
	especie 			varchar(50),
	fechaEncuentro 		date NOT NULL,
	hora 				timestamp,
	descripcion 		TEXT NOT NULL,
	foto 				bytea NOT NULL,
	zona 				varchar (50) NOT NULL,
	tamaño 				NUMERIC, 
	peso 				NUMERIC,
	sexo				char,
	CONSTRAINT pk_encuentro PRIMARY KEY (usuario,especie),
	CONSTRAINT sex_check CHECK (sexo ILIKE 'M' OR sexo ILIKE 'F')
);

CREATE TABLE producto (
	id_producto 		serial,
	nombre				varchar (50) NOT NULL,
	precioU 			NUMERIC NOT NULL,
	descripcion 		TEXT NOT NULL,
	valoracion 			SMALLINT NOT NULL,
	categoria 			varchar(50),
	CONSTRAINT 	pk_producto PRIMARY KEY (id_producto),
	CONSTRAINT valoracion_check CHECK (valoracion BETWEEN 1 AND 5)
);

CREATE TABLE lineaVenta(
	linea_cod			serial,
	cod_venta 			int,
	id_producto			int,
	uds 				SMALLINT NOT NULL,
	precioTotal			NUMERIC NOT NULL,
	CONSTRAINT pk_lineaVenta PRIMARY KEY (linea_cod,cod_venta)
);

CREATE TABLE venta(
	id_venta 			serial,
	cliente 			int,
	fecha				date NOT NULL,
	total 				NUMERIC NOT NULL,
	CONSTRAINT pk_venta PRIMARY KEY (id_venta)
);


ALTER TABLE encuentro 
ADD CONSTRAINT fk_usuario FOREIGN KEY (usuario) REFERENCES cliente,
ADD CONSTRAINT fk_especie FOREIGN KEY (especie) REFERENCES especie;

ALTER TABLE especie 
ADD CONSTRAINT fk_genero FOREIGN KEY (genero) REFERENCES genero;
ALTER TABLE genero  
ADD CONSTRAINT fk_familia FOREIGN KEY (familia) REFERENCES familia;
ALTER TABLE familia 
ADD CONSTRAINT fk_orden FOREIGN KEY (orden) REFERENCES orden;
ALTER TABLE orden  
ADD CONSTRAINT fk_clase FOREIGN KEY (clase) REFERENCES clase;
ALTER TABLE clase 
ADD CONSTRAINT fk_filo FOREIGN KEY (filo) REFERENCES filo;
ALTER TABLE filo  
ADD CONSTRAINT fk_reino FOREIGN KEY (reino) REFERENCES reino;

ALTER TABLE lineaventa 
ADD CONSTRAINT fk_cod_venta FOREIGN KEY (cod_venta) REFERENCES venta,
ADD CONSTRAINT fk_id_producto FOREIGN KEY (id_producto) REFERENCES producto;

ALTER TABLE venta
ADD CONSTRAINT fk_cliente FOREIGN KEY (cliente) REFERENCES cliente;

INSERT INTO reino VALUES 
('animalia','Los animales son seres pluricelulares y eucariotas de alimentación heterótrofa, respiración aeróbica, reproducción sexual y capacidad de desplazamiento.');

INSERT INTO filo VALUES
('arthropoda','Los artrópodos constituyen uno de los grandes filos del reino animal, subdividido en diversas clases, algunas de las cuales cuentan con gran número de géneros y especies. Se los denomina de esta manera por estar provistos de patas articuladas.','animalia'),
('chordata','Chordata es un filo en el reino animal que incluye a los vertebrados, junto con algunos animales invertebrados como las tunicas y los anfioxos. Los animales de este filo poseen una cuerda dorsal o notocorda, que se extiende a lo largo del cuerpo y les da soporte. También tienen una estructura de tubo nervioso, un órgano sensorial principal (como los ojos y los oídos) y branquias o pulmones para la respiración. Además, los chordata poseen el tubo digestivo completo, lo que significa que tienen una boca y un ano. Los vertebrados, la clase más conocida de chordata, también tienen una columna vertebral que protege la médula espinal y algunos otros rasgos distintivos, como la presencia de dientes y el desarrollo de extremidades.','animalia');

INSERT INTO clase VALUES 
('arachnida','Arachnida es una clase de animales invertebrados que se caracterizan por tener ocho patas. Son inclusivos spiders, scorpions, ticks, y más. Generalmente, tienen un cuerpo segmentado y una cabeza que se fusiona con el tórax. La mayoría de los miembros de la clase respiran a través de pulmones en lugar de branquias. También poseen quelíceros (apéndices en forma de pinzas) que utilizan para aplastar y desgarrar la comida, así como un par de pedipalpos que les ayudan a manipular la presa. Muchas especies de arañas y escorpiones son venenosas, utilizando sus quelíceros o su cola, respectivamente para inyectar veneno en sus presas o depredadores.','arthropoda'),
('insecta','Insecta es una clase de animales que engloba a los insectos, arañas, ciempiés y otros artrópodos. Estos animales se caracterizan por tener un cuerpo segmentado, seis patas, antenas y en muchos casos, alas. Los insectos son la mayoría de las especies de la clase Insecta, y son cruciales para el equilibrio ecológico. Son importantes polinizadores y decomponedores, además de ser una fuente de alimento para muchos otros animales. Las arañas y ciempiés, aunque no son insectos, también cumplen importantes roles en los ecosistemas como controladores de poblaciones de otros artrópodos.','arthropoda'),
('chilopoda','Los quilópodos, también conocidos como ciempiés, son un grupo de animales pertenecientes a la clase Chilopoda. Estos invertebrados tienen un cuerpo largo y segmentado con muchas patas. Su cabeza tiene un par de antenas largas y a menudo tienen garras venenosas que utilizan para capturar presas y defenderse de los depredadores. Los quilópodos se encuentran en todo el mundo y habitan en una amplia variedad de hábitats, incluyendo bosques, desiertos y riberas de ríos. Son depredadores activos, alimentándose de otros insectos y pequeños animales. Algunas especies de quilópodos son consideradas como plagas, mientras que otros son valorados por su papel en el control de poblaciones de otros organismos dañinos.','arthropoda'),
('malacostraca','Los malacostráceos son un subclase de crustáceos, que se caracterizan por tener un cuerpo segmentado, protegido por un exoesqueleto, que les permite protegerse y moverse con agilidad. Entre los malacostráceos se encuentran importantes grupos como los cangrejos, langostas, camarones y kril. Estos animales pueden vivir en diferentes ambientes acuáticos, desde aguas saladas hasta dulces, y desempeñan roles importantes en la cadena alimentaria de los ecosistemas acuáticos. Algunas especies de malacostráceos son explotadas comercialmente por su carne y otras propiedades, mientras que otras tienen importancia en la investigación científica por su capacidad de regeneración y adaptación a condiciones extremas.','arthropoda'),
('amphibia','"Amphibia" es una serie animada estadounidense creada por Matt Braly, que sigue las aventuras de una chica adolescente llamada Anne Boonchuy, quien es transportada a un mundo de animales antropomórficos y criaturas mágicas después de encontrar un extraño amuleto en un pantano. Allí, Anne se hace amiga de un sapo llamado Sprig Plantar y su familia, quienes la ayudan a adaptarse a su nueva vida en Amphibia mientras buscan una forma de enviarla de vuelta a casa. La serie combina humor, aventura, magia y misterio en un mundo colorido y fantástico que, además de entretener a los espectadores, también aborda temas como la amistad, la familia y la aceptación de la diversidad.','chordata'),
('reptilia','Reptilia es una clase de animales vertebrados que poseen características únicas, como la piel escamosa y seca, respiración pulmonar y la capacidad de regular su temperatura corporal. Son ovíparos y existen alrededor de 10,000 especies en todo el mundo, desde pequeñas lagartijas hasta grandes cocodrilos. Los reptiles se dividen en cuatro órdenes: Squamata (serpientes y lagartos), Testudines (tortugas y tortugas terrestres), Crocodylia (cocodrilos, caimanes y gaviales) y Rhynchocephalia (tuatara). Estos animales pueden encontrarse en numerosos hábitats, desde bosques y praderas hasta desiertos y océanos.','chordata');

INSERT INTO orden VALUES
('araneae','Aranae es un término que se utiliza para referirse al orden de arácnidos, que incluye a las arañas, escorpiones y ácaros, entre otros. Las arañas son animales que tienen ocho patas y dos quelíceros, los cuales utilizan para inyectar veneno en sus presas. También tienen una gran variedad de adaptaciones para cazar, como producir telarañas para atrapar insectos y otros animales. Además, las arañas son depredadores importantes en muchos ecosistemas, ya que se alimentan de plagas y ayudan a controlar sus poblaciones. En resumen, Aranae es un grupo de artrópodos que incluye a las arañas, importantes depredadores en muchos ecosistemas y con una gran variedad de adaptaciones para cazar.','arachnida'),
('scorpiones','Scorpiones es un orden de artrópodos arácnidos depredadores conocidos comúnmente como escorpiones o alacranes. Se caracterizan por contar con un par de pinzas de agarre y una cola estrecha y segmentada, a menudo formando una reconocible curva hacia delante sobre la espalda y siempre rematada con un aguijón.','arachnida'),
('pseudoscorpiones','Los pseudoscorpiones son arácnidos pequeños que pueden medir desde 1 hasta 10 milímetros de longitud. Su cuerpo es aplanado dorsoventralmente y tienen dos quelíceros en forma de pinzas que les permiten cazar presas. Su nombre se debe a que parecen escorpiones en miniatura, pero a diferencia de estos, los pseudoscorpiones no tienen cola ni aguijón venenoso. Por tanto, no representan ningún peligro para los humanos. Suelen habitar en ambientes húmedos como suelos forestales, musgos y hojarasca. Se alimentan de pequeños invertebrados como ácaros, insectos y otros arácnidos. A pesar de su pequeño tamaño, cumplen un papel importante en el equilibrio ecológico de muchos ecosistemas.','arachnida'),
('opiliones','Los opiliones, también conocidos como arañas-cosecha o patas largas, son una orden de arácnidos que se caracterizan por tener un cuerpo alargado y unas patas extremadamente largas. A diferencia de las arañas, los opiliones no tienen glándulas venenosas y no son capaces de producir seda. Aunque algunos opiliones tienen un aspecto similar a las arañas, se pueden diferenciar fácilmente por su cuerpo y sus patas, que no están segmentadas como las de las arañas. Además, los opiliones no son capaces de producir telarañas. Los opiliones son prédateurs y se alimentan de insectos, arañas y otros pequeños invertebrados.','arachnida'),
('mecoptera','Los mecoptera, también conocidos como "moscas escorpión", son un orden de insectos que se encuentran en todo el mundo, aunque son más comunes en climas cálidos. Tienen un cuerpo largo y delgado con una cabeza pequeña y antenas largas y delgadas. Sus alas son membranosas y se pliegan en un patrón de techo sobre su espalda. Algunas especies tienen una apariencia notablemente similar a la de los escorpiones, con una estructura de apariencia dura y un aguijón en la cola. Sin embargo, a diferencia de los escorpiones, los mecoptera no son venenosos y no tienen la capacidad de lastimar a los seres humanos.','insecta'),
('lepidoptera','Los lepidópteros son un grupo diverso de insectos que se caracterizan por poseer alas membranosas cubiertas de escamas, dando la apariencia de polvo o brillo. Esto incluye a las mariposas diurnas y nocturnas, así como a las polillas. La mayoría de los lepidópteros tienen una fase larval y pupal antes de convertirse en un adulto alado, y utilizan una gran variedad de plantas para su alimentación y desarrollo. También son importantes polinizadores y fuente de alimento para otros animales. La belleza y variabilidad de sus alas las hace un objeto de estudio y admiración por parte de científicos y entusiastas por igual.','insecta'),
('coleoptera','Coleoptera es el orden de insectos más grande del mundo, con alrededor de 400,000 especies descritas. Comúnmente conocidos como escarabajos, los coleópteros son algunos de los insectos más familiares y diversos. Se encuentran en una amplia gama de hábitats, desde desiertos hasta bosques lluviosos y desde la tundra ártica hasta las selvas tropicales. Los escarabajos varían en tamaño desde menos de un milímetro hasta varios centímetros de largo y tienen una gran variedad de formas y colores. La mayoría de las especies de coleópteros se alimentan de plantas, mientras que otras se alimentan de materia muerta o de otros insectos. Algunas especies de escarabajos son consideradas plagas, aunque muchas son beneficiosas para el medio ambiente y la salud humana.','insecta'),
('dermaptera','Los Dermaptera, comúnmente conocidos como tijeretas o cortapicos, son un orden de insectos que se caracterizan por sus pinzas en la parte posterior del abdomen. La mayoría de las especies son carnívoras y se alimentan de otros insectos y arañas, aunque algunas también se alimentan de materia vegetal en descomposición. Estos insectos tienen un cuerpo aplanado y alargado, con antenas largas y delgadas. Las alas de algunos especímenes son reducidas o están ausentes y suelen ser activos durante la noche. Las tijeretas tienen una gran diversidad de tamaños, desde 3 mm hasta cerca de 10 cm. Aunque algunas especies se consideran plagas en las cosechas, los Dermaptera no son dañinos para los seres humanos y no transmiten enfermedades.','insecta'),
('orthoptera','Orthoptera es un orden de insectos caracterizado por sus patas traseras adaptadas para saltar y por la presencia de dos pares de alas, siendo las delanteras más duras que las posteriores. También se destacan por sus antenas, que son largas y filiformes. Dentro de este orden se pueden encontrar diversas especies como los grillos, langostas, saltamontes y chicharras, entre otros. Estos insectos son importante en la cadena alimentaria ya que son una fuente de alimento para otras especies de animales, como aves y reptiles. Además, los grillos son utilizados en algunos países como mascotas o para fines culinarios, ya que son ricos en proteínas. De manera general, los Orthoptera tienen una amplia distribución geográfica y son comunes en todo el mundo.','insecta'),
('hemiptera','Los Hemipteros son un orden de insectos que se caracterizan por tener un par de alas duras y membranosas. También se les conoce como chinches o heterópteros. Las chinches tienen un pico largo y delgado, que utilizan para succionar líquidos de plantas y animales. A pesar de que la mayoría de las chinches son consideradas como plagas, algunas son benéficas para el ser humano, ya que se alimentan de pulgones u otras especies dañinas. Los Hemipteros son muy abundantes y es posible encontrarlos en una gran variedad de hábitats: desde zonas acuáticas hasta zonas terrestres, desde los trópicos hasta los polos. Además, su gran adaptabilidad les permite sobrevivir en ambientes extremos como el desierto o la tundra.','insecta'),
('scolopendromorpha','Scolopendromorpha es un orden de artrópodos que incluye a los ciempiés gigantes. Se caracterizan por tener un cuerpo largo y segmentado, con numerosas patas y mandíbulas fuertes. Aunque pueden ser de gran tamaño, algunos superan los 30 centímetros, son animales solitarios y nocturnos que prefieren la oscuridad de las madrigueras o cuevas. Son depredadores activos, alimentándose de otros artrópodos e invertebrados pequeños. Algunas especies pueden ser venenosas y resultar peligrosas para el ser humano si se las molesta o se les provoca.','chilopoda'),
('lithobiomorpha','Lithobiomorpha es un grupo de miriápodos que se caracterizan por tener un cuerpo alargado y segmentado, con numerosas patas y una mandíbula prominente. Son predadores activos y pueden ser encontrados en una variedad de hábitats, desde el suelo de los bosques hasta las zonas rocosas de las costas. Los Lithobiomorpha se distinguen de otros miriápodos por tener una columna vertebral más rígida y por ser más ágiles y veloces en sus movimientos. Algunas especies de Lithobiomorpha son capaces de producir veneno para defenderse de posibles depredadores. A pesar de que son generalmente considerados inofensivos para los humanos, pueden morder y causar picaduras dolorosas.','chilopoda'),
('decapoda','Los decápodos son un orden de crustáceos con diez patas, que incluye a los cangrejos, langostas, camarones y langostinos. Son animales acuáticos y se encuentran en mares, ríos y agua dulce. Se caracterizan por tener un cuerpo dividido en dos regiones principales: la cabeza, que contiene los ojos, antenas y mandíbulas, y el cefalotórax, que fusiona el tórax y la cabeza y contiene los apéndices locomotores y branquias. Los machos suelen tener las patas más grandes, especialmente las dos primeras, que utilizan para luchar por las hembras.','malacostraca'),
('anura','Los anuros son un orden de anfibios caracterizados por carecer de cola en su estado adulto. Incluyen a las ranas y a los sapos, que se diferencian principalmente por su piel y hábitos de vida. Los anuros tienen una piel desnuda y húmeda, que les permite respirar a través de ella. Son semiacuáticos y se reproducen poniendo sus huevos en el agua. Tienen una dieta variada, que incluye insectos, lombrices, moluscos y pequeños vertebrados. Son importantes en la alimentación de otros animales y en el control de plagas. Los anuros son una parte importante de la biodiversidad del planeta, pero muchas especies están en peligro debido a la destrucción de su hábitat y otros factores antropogénicos.','amphibia'),
('urodelos','Los urodelos son un grupo de anfibios que incluyen las salamandras, tritones y ajolotes. Estos animales tienen cuerpos alargados y delgados, con cuatro patas y una cola bien desarrollada. Se caracterizan por su capacidad para regenerar extremidades perdidas o dañadas, así como por su piel húmeda y respiración branquial en algunas fases de su ciclo de vida. Los urodelos son animales nocturnos y acuáticos en su mayoría, aunque algunas especies pueden vivir en ambientes terrestres y húmedos. En cuanto a su alimentación, suelen ser carnívoros y se alimentan principalmente de insectos, crustáceos y otros pequeños seres acuáticos.','amphibia'),
('testudines','Las Testudines son un grupo de reptiles que también son conocidos como tortugas. Las tortugas tienen características especiales que las diferencian de otros reptiles, como su caparazón, que les proporciona protección y se compone de dos partes, la superior y la inferior, que están unidas por un puente óseo. Además, su cabeza es pequeña y está cubierta por un caparazón óseo llamado cráneo. Las tortugas son animales que pueden vivir tanto en tierra como en agua. Se alimentan principalmente de plantas y otros invertebrados. Otras características notables de las tortugas son su longevidad, ya que pueden vivir hasta 200 años, y su capacidad para retirar sus extremidades y cabeza dentro del caparazón como modo de protección.','reptilia'),
('squamata','Squamata es un orden de reptiles que incluye a las serpientes, lagartos y camaleones. Estos animales se caracterizan por la presencia de escamas en su piel, lo que les da una apariencia lisa y brillante. Además, tienen una lengua bifurcada que les permite detectar olores y captar información de su entorno. Los miembros de este grupo de reptiles son muy diversos tanto en su morfología como en su forma de vida, desde especies adaptadas a vivir en el suelo hasta otras que trepan árboles o son completamente acuáticas. Squamata tiene una distribución mundial, aunque se concentran principalmente en áreas tropicales y subtropicales. Algunas especies son importantes económicamente para ser utilizadas como alimento, medicina o mascotas.','reptilia' );

INSERT INTO familia VALUES 
('agelenidae','Los agelénidos (Agelenidae) son una familia de arañas araneomorfas constructoras de telas de araña que tiene cerca de 500 especies en 40 géneros en todo el mundo. Ver texto. Destacan la especie europea venenosa Tegenaria agrestis.','araneae'),
('dysderidae','Los Dysderidae son una familia de arañas araneomorfas que se encuentran en todo el mundo. Su cuerpo es aplanado y sin brillo, de color marrón oscuro o negro. A menudo se confunden con las arañas lobo debido a su apariencia similar. Estas arañas tienen seis ojos en dos filas de tres, y tienen una forma distintiva de caminar sobre sus patas, con las dos primeras patas extendidas hacia adelante y las dos últimas extendidas hacia atrás. Las Dysderidae son principalmente arañas nocturnas y suenan como un clic audible cuando se acercan a su presa. No son comunes en las viviendas humanas, pero cuando se encuentran pueden ser una molestia debido a su mordedura venenosa, que puede causar dolor e hinchazón en la zona afectada.','araneae'),
('gnaphosidae','Gnaphosidae es una familia de arañas que se encuentran en todo el mundo. Se caracterizan por tener un cuerpo plano y bajo, con patas largas y delgadas. Algunas especies pueden ser de colores brillantes, mientras que otras son de colores oscuros y difíciles de ver. Estas arañas son depredadoras activas que cazan a sus presas en el suelo o entre hojas y ramas bajas. La mayoría de las especies son inofensivas para los humanos y no muerden a menos que se sientan amenazadas. Algunas especies de Gnaphosidae se han estudiado por sus propiedades venenosas y su uso potencial en la medicina.','araneae'),
('lycosidae','Lycosidae es una familia de arañas que se encuentran en todo el mundo. Estas arañas son conocidas como "arañas lobo" debido a su capacidad de cazar activamente presas en lugar de esperar pasivamente en su tela de araña. Tienen una estructura del cuerpo similar a la de otras arañas, con ocho patas, quelíceros y pedipalpos. A menudo son de tamaño mediano a grande y pueden ser de color marrón, gris o negro. Las arañas lobo tienen una mordedura venenosa, pero rara vez son peligrosas para los humanos. Lycosidae juegan un papel importante en el control natural de insectos y otros artrópodos en el medio ambiente y son una parte esencial del ecosistema en el que viven.','araneae'),
('palpimanidae','Palpimanidae es una familia de arañas que se caracteriza por tener un aspecto similar a un escorpión. Son arañas pequeñas y nocturnas que se encuentran en todo el mundo. La mayoría de las especies se encuentran en Australia y Sudamérica, pero también se pueden encontrar en regiones tropicales y subtropicales de África, Asia y América del Norte. Estas arañas tienen cuerpos planos y patas delgadas, que les permiten moverse por espacios estrechos en busca de presas. Aunque tienen quelíceros que se asemejan a los de un escorpión, no son venenosas y son generalmente inofensivas para los seres humanos.','araneae'),
('pisauridae','Son arañas grandes que se parecen a las arañas lobo (Lycosidae) en la forma que tienen de cazar y atrapar a la presa. Su caparazón es ovalado con marcas longitudinales. Las hembras llevan las ootecas, parte que las integra en los quelíceros, colgando bajo su cuerpo.','araneae'),
('salticidae','Salticidae es una familia de arañas conocidas como arañas saltarinas debido a su capacidad para saltar grandes distancias en comparación con otras arañas. Son de tamaño pequeño a mediano, generalmente de 1 a 2 centímetros de longitud, y tienen un cuerpo redondeado y peludo. Estas arañas son depredadoras activas y cazan a sus presas emboscándolas o persiguiéndolas. Los saltícidos tienen una excelente visión y, por lo general, utilizan sus ocho ojos para rastrear y cazar a sus presas. La mayoría de las especies de Salticidae son inofensivas para los humanos y se encuentran comúnmente en espacios abiertos y soleados como praderas y jardines.','araneae'),
('sparassidae','Los Sparassidae, también conocidos como arañas cangrejo o arañas de patas largas, son una familia de arañas que se encuentran en todo el mundo, especialmente en climas cálidos. Estas arañas tienen cuerpos grandes y pelos gruesos, y pueden variar en color desde marrón claro hasta negro. Tienen ocho patas largas y dos pares de ojos grandes en la parte delantera de la cabeza. A diferencia de muchas otras arañas, las Sparassidae cazan activamente a sus presas en lugar de tejer una telaraña y esperar a que las presas se enreden. Son excelentes cazadoras y pueden presa de animales más grandes que ellas mismas.','araneae'),
('theridiidae','Theridiidae es una familia de arañas que se encuentran en todo el mundo. Las arañas de esta familia tienen un cuerpo pequeño y redondo y patas cortas, además de dos glándulas de seda en la parte posterior del cuerpo. A menudo tienen un patrón característico en el dorso del abdomen en forma de cruz o puntos. Algunas especies son venenosas pero su veneno no es considerado peligroso para los humanos. Estas arañas son generalmente tejerinas activas que prefieren construir sus telarañas en lugares oscuros y protegidos como entre las hojas, debajo de techos y en las esquinas de las paredes. ','araneae'),
('thomisidae','Thomisidae es una familia de arañas conocidas como arañas cangrejo debido a su apariencia y forma de caminar. Se encuentran en todo el mundo, con alrededor de 175 géneros y más de 2,100 especies que han sido identificadas hasta la fecha. A menudo se les encuentra en flores y plantas, por lo que se les conoce como cazadoras de emboscada. Por lo general, son de tamaño pequeño o mediano, y tienen patas largas y una envergadura relativamente grande. No construyen telas, sino que se esconden en posición de emboscada, esperando a que una presa se acerque lo suficiente para capturarla. Algunas especies, sin embargo, construyen refugios como hojas entrelazadas y ramitas.','araneae'),
('hexathelidae','Los Hexathelidae son una familia de arañas venenosas que se encuentran principalmente en el hemisferio sur, en áreas tropicales y subtropicales. Estas arañas son conocidas comúnmente como arañas del embudo debido a su técnica de caza, en la que construyen un embudo de seda en el suelo para capturar a sus presas. Las Hexathelidae a menudo tienen una apariencia oscura y robusta, y su veneno puede ser peligroso para los seres humanos. Muchas especies de Hexathelidae pueden ser encontradas en Australia, incluyendo la famosa araña de embudo Sydney (Atrax robustus), que es considerada una de las arañas más venenosas en el mundo.','araneae'),
('nemesiidae','Los nemésidos o nemesíidos (Nemesiidae) son una familia de arañas migalomorfas, y los únicos miembros de la superfamilia Nemesioidea. Calisoga sp. Fueron consideradas parte de la familia Dipluridae. Son arañas relativamente grandes, pardas, alargadas y con patas robustas.','araneae'),
('buthidae','Buthidae es una familia de escorpiones que se encuentra en todo el mundo con mayor diversidad en regiones cálidas y áridas. Los escorpiones Buthidae se caracterizan por tener cuerpos planos y prolongados, pinzas grandes y un aguijón venenoso en la punta de la cola. Son principalmente nocturnos y se alimentan de insectos, arácnidos y otros invertebrados pequeños. Algunas especies de Buthidae son conocidas por su veneno mortal, que puede causar graves problemas de salud o incluso la muerte. Sin embargo, también se ha demostrado que los componentes del veneno son útiles en la investigación científica y en la producción de medicamentos. ','scorpiones'),
('opiliones','Los opiliones, también conocidos como arañas-cosecha o patas largas, son una orden de arácnidos que se caracterizan por tener un cuerpo alargado y unas patas extremadamente largas. A diferencia de las arañas, los opiliones no tienen glándulas venenosas y no son capaces de producir seda. Aunque algunos opiliones tienen un aspecto similar a las arañas, se pueden diferenciar fácilmente por su cuerpo y sus patas, que no están segmentadas como las de las arañas. Además, los opiliones no son capaces de producir telarañas. Los opiliones son prédateurs y se alimentan de insectos, arañas y otros pequeños invertebrados.','opiliones'),
('panorpidae','Los Panorpidae son una familia de insectos que se encuentran en todo el mundo. Físicamente, tienen un cuerpo delgado y largas patas y antenas. Además, tienen una boca masticadora y alas membranosas. La característica más distintiva de los Panorpidae es su apéndice abdominal masculino, que se asemeja a una cola de escorpión. Sin embargo, este apéndice no es peligroso y se utiliza durante la cópula. Las hembras también tienen un apéndice abdominal, pero es menos prominente que el de los machos. La mayoría de las especies de Panorpidae se alimentan de insectos pequeños y pueden ser útiles como control de plagas en la agricultura.','mecoptera'),
('nymphalidae','Las Nymphalidae son una familia extensa de mariposas, con más de 6000 especies conocidas en todo el mundo. Son conocidas por su tamaño relativamente grande, sus colores brillantes y sus patrones llamativos en las alas. A menudo pueden ser reconocidas por su patrón de "ojos" en las alas posteriores, que se cree que sirve como defensa contra los depredadores. Las larvas de las Nymphalidae se alimentan de una gran variedad de plantas, lo que los convierte en importantes polinizadores en muchos ecosistemas diferentes. Muchas especies de Nymphalidae están amenazadas por la degradación de los hábitats naturales y la pérdida de especies vegetales importantes.','lepidoptera'),
('arctiidae','Arctiidae es una familia de insectos lepidópteros que se caracteriza por la presencia de pelos o escamas en su cuerpo, que pueden ser cortos o largos y gruesos, y que les dan una apariencia peluda. Estos insectos son de tamaño mediano a grande y se encuentran en todo el mundo. Muchas especies pueden ser encontradas en zonas tropicales y subtropicales, y algunas habitan áreas frías. Las mariposas de la familia Arctiidae son conocidas por su colorido y a menudo tienen patrones en su cuerpo y alas que son muy atractivos. Estos insectos tienen diferentes hábitos alimenticios: algunas especies se alimentan de néctar, mientras que otras comen hojas de plantas y árboles.','lepidoptera'),
('carabidae','Los Carábidos, también conocidos como escarabajos terrestres, son una familia de insectos que se encuentra en todo el mundo. Son conocidos por su cuerpo alargado y sus patas largas, las cuales les permiten moverse con rapidez en el suelo. Los Carábidos son depredadores que se alimentan de otros insectos, como hormigas, gusanos y orugas. Además, son importantes en el control natural de plagas en los cultivos agrícolas. La mayoría de los Carábidos tienen un aspecto oscuro y brillante, con un exoesqueleto resistente y una cabeza grande y fuerte. Son una familia amplia y diversa, que incluye más de 40,000 especies diferentes. Estos insectos son importantes en el ecosistema y fascinantes para estudiar debido a su gran diversidad.','coleoptera'),
('labiduridae','La familia Labiduridae son insectos de cuerpo plano que se encuentran comúnmente en áreas tropicales y subtropicales. También se les conoce como tijeretas o ciempiés dorados, ya que tienen un color dorado brillante y se asemejan a los ciempiés con sus patas largas y delgadas. Se caracterizan por tener mandíbulas fuertes y emiten un fuerte olor cuando se sienten amenazados. Son depredadores nocturnos que se alimentan de otros insectos y pequeños invertebrados. Estos insectos suelen encontrarse bajo piedras, troncos y en otros lugares oscuros y húmedos. A pesar de su apariencia aterradora, no son venenosos para los humanos y no representan una amenaza grave.','dermaptera'),
('gryllidae','Los Gryllidae son una familia de insectos en la orden Orthoptera que incluye los grillos verdaderos. Estos insectos tienen cuerpo alargado y aplanado, con patas fuertes y traseras que les permiten saltar grandes distancias. Los grillos son conocidos por su distintivo canto, producido por frotar sus alas. Además de ser un sonido agradable en la naturaleza, el canto de los grillos es utilizado como un medio de comunicación entre ellos. Los Gryllidae se encuentran en todo el mundo, en una variedad de hábitats, desde bosques hasta campos abiertos y pueden ser beneficiosos como polinizadores y controladores de plagas, así como también como alimento para otros animales. En algunas culturas, los grillos son considerados como símbolos de buena suerte y fortuna.','orthoptera'),
('lygaeidae','Lygaeidae es una familia de insectos conocidos comúnmente como chinches de tierra o chinches de semillas. Son pequeños, con una longitud que oscila entre 3 y 12 mm, y poseen una gran variedad de colores, como negro, marrón, rojo o amarillo. Estos insectos se alimentan de plantas, principalmente de semillas, y algunos miembros de la familia son considerados plagas de cultivos. Aunque muchas especies de Lygaeidae son inofensivas para los humanos, algunas pueden emitir un olor desagradable como método de defensa cuando se sienten amenazadas. Además, algunos ejemplares pueden transmitir enfermedades a las plantas, lo que puede causar daños significativos en la agricultura.','hemiptera'),
(),
(),
(),
(),
(),
(),
(),
(),
(),
(),
(),
(),