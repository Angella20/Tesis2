* 1. Encuesta Nacional de Hogares (ENAHO)
clear all  // Limpiar la memoria de Stata

// Definir rutas globales
global main   "C:/Users/SINERGY TECH/Desktop/STATA_TESIS" // Ruta principal
global dta    "$main/Datos"                               // Carpeta de datos
global works  "$main/Trabajadas"                          // Carpeta de resultados

// Cambiar al directorio de datos
cd "$dta"

// Realizar análisis Unicode, configurar la codificación y traducir archivos de datos
// Modulo1 - Características de la Vivienda y del Hogar
unicode analyze "enaho01-2020-100.dta"   // Analizar la codificación de caracteres
unicode encoding set "latin1"            // Establecer la codificación a latin1
unicode translate "enaho01-2020-100.dta" // Traducir a latin1

// Modulo 2 - 	Características de los Miembros del Hogar
unicode analyze "enaho01-2020-200.dta"
unicode encoding set "latin1"
unicode translate "enaho01-2020-200.dta"

// Modulo 3 - 	Educación
unicode analyze "enaho01a-2020-300.dta"
unicode encoding set "latin1"
unicode translate "enaho01a-2020-300.dta"


// Agregar Sumaria para traer los niveles socioeconomicos 
// Factor de expansión 


* Módulo 1: (modulo_hogar)

// Variables de interés: Alumbrado - Celular e Internet
use "$dta/enaho01-2020-100.dta", clear
keep conglome vivienda hogar ubigeo dominio estrato p1121 p1123 p1124 p1125 p1126 p1127 p1142 p1144 

preserve
save "$works/modulo_hogar", replace
restore
browse

* Módulo 2: (modulo_miembros)

// Variables de interés: Parentesco Sexo y Edad
use "$dta/enaho01-2020-200.dta", clear
keep conglome vivienda hogar ubigeo dominio estrato codperso p203b p207 p208a 

preserve
save "$works/modulo_miembros", replace
restore
browse

* Módulo 3: (modulo_educa)

// Variables de interés
use "$dta/enaho01a-2020-300.dta", clear
keep conglome vivienda hogar ubigeo dominio estrato codperso p300a p304a ///
p307a1 p307a2 p307a3 p307a4 p307a4_5 p307a4_6 p307a4_7 ///
p307b1 p307b2 p307b3 p307b4 p307b4_5 p307b4_6 p307b4_7 ///
p308a p308d p314a ///
p314b_1 p314b_2 p314b_3 p314b_4 p314b_5 p314b_6 p314b_7 ///
p314b1_1 p314b1_2 p314b1_8 p314b1_9 p314b1_6 p314b1_7 p314d p316_1 ///
p316_2 p316_3 p316_4 p316_5 p316_6 p316_7 p316_8 p316_9 p316_10 p316_11 p316_12 ///
p316a1 p316b p316c1 p316c2 p316c3 p316c4 p316c5 p316c6  p316c7 p316c8 p316c9 ///
p316c10 t313

preserve
save "$works/modulo_educa", replace
restore
browse


* Combinar módulo_hogar y módulo_miembros en hogar_miembros
// Cargar el archivo de datos del módulo_hogar
use "$works/modulo_hogar", clear

// Combinar módulo_hogar y módulo_miembros utilizando variables de identificación
merge m:m conglome vivienda hogar ubigeo dominio estrato using "$works/modulo_miembros.dta"

// Eliminar la variable _merge que se crea al combinar
drop _merge

// Guardar el resultado en una nueva ubicación
save "$works/hogar_miembros", replace
browse

// Se combina la información del hogar y los miembros en un solo conjunto de datos llamado hogar_miembros.
// Cargar el archivo de datos hogar_miembros
use "$works/hogar_miembros", clear

// Combinar hogar_miembros y módulo_educa utilizando variables de identificación
merge m:m conglome vivienda hogar ubigeo dominio estrato using "$works/modulo_educa.dta"

// Guardar el resultado en una nueva ubicación
save "$works/base_final", replace

// Se combina la información del hogar y los miembros con la información educativa en un conjunto de datos final llamado base_final.


* Trabajamos con la base final

// Cargar la base de datos base_final
use "$works/base_final", clear

// Crear una variable "departamento" extrayendo los primeros 2 dígitos de "ubigeo"
gen departamento = substr(ubigeo, 1, 2)

// Convertir la variable "departamento" a tipo de dato numérico y reemplazar los valores
destring departamento, replace

// Recodificar la variable "departamento" para asignar nombres a los códigos numéricos
recode departamento (1=1 "Amazonas") (2=2 "Ancash") (3=3 "Apurímac") (4=4 "Arequipa") ///
(5=5 "Ayacucho") (6=6 "Cajamarca") (7=7 "Callao") (8=8 "Cusco") (9=9 "Huancavelica") ///
(10=10 "Huánuco") (11=11 "Ica") (12=12 "Junín") (13=13 "La Libertad") (14=14 "Lambayeque") ///
(15=15 "Lima") (16=16 "Loreto") (17=17 "Madre de Dios") (18=18 "Moquegua") ///
(19=19 "Pasco") (20=20 "Piura") (21=21 "Puno") (22=22 "San Martín") (23=23 "Tacna") ///
(24=24 "Tumbes") (25=25 "Ucayali"), gen(dpto)

// Recodificar la variable "estrato" para crear la variable "area"
recode estrato(1/5=1) (6/8=0), gen(area)

// Definir etiquetas para la variable "area"
label define lab_area 1 "Urbano" 0 "Rural"

// Asignar etiquetas a la variable "area" usando la definición anterior
recode dominio(1/3=1 "Costa") (4/6=2 "Sierra") (7/7=3 "Selva") (8/8=4 "Lima Metropolitana"), gen(zona)

// Ver los datos después de las transformaciones
browse



* Eliminar observaciones donde p308a es mayor o igual a 4 y p208a es mayor o igual a 18
drop if p308a >= 4
drop if p208a >= 18

// Realizar una copia de seguridad de los datos actuales
preserve
save "$works/base_1", replace
restore

// Crear tablas de frecuencia para variables específicas
tab p308a // Tabla de frecuencia para p308a
tab p207  // Tabla de frecuencia para p207
tab p308d // Tabla de frecuencia para p308d

// Tablas de frecuencia cruzada entre "area" y otras variables
tab area p308d, nofreq cell
tab area p314a, nofreq cell
tab area p314b_1, nofreq cell

// Renombrar variables para darles nombres más descriptivos
rename p1121 alumbrado_electricidad
rename p1123 alumbrado_petroleo
rename p1124 alumbrado_vela
rename p1125 alumbrado_generador
rename p1126 alumbrado_otro
rename p1127 alumbrado_no_usa
rename p1142 Celular
rename p1144 Internet
rename p203b relacion_parentesco
rename p207 sexo
rename p208a edad
rename p300a idioma
rename p304a grado_año_pasado
rename p308a grado_actual
rename p308d centro_estudios
rename p314a uso_internet
rename p314b_1 uso_internet_hogar
rename p314b_2 uso_internet_trabajo
rename p314b_3 uso_internet_centro_educativo
rename p314b_4 uso_internet_centro_cabina
rename p314b_5 uso_internet_centro_otra_persona
rename p314b_6 uso_internet_otro
rename p314b_7 uso_internet_movil
rename p314b1_1 uso_internet_computadora
rename p314b1_2 uso_internet_laptop
rename p314b1_9 uso_internet_celular_con_datos
rename p314b1_6 uso_internet_tablet
rename p314b1_7 uso_internet_con_otro
rename p314d freq_uso
rename p316_1 aprop_obtener_informacion
rename p316_2 aprop_comunicarse
rename p316_3 aprop_comprar_producto
rename p316_4 aprop_banca
rename p316_5 aprop_educacion_formal
rename p316_6 aprop_transacciones
rename p316_7 aprop_entretenimiento
rename p316_8 aprop_vender_productos
rename p316_9 aprop_otros
rename p316_12 aprop_software
rename p316a1 teléfono_celular_propio
rename p316b uso_equipo_de_cómputo
rename p316c1 act_informaticas_mover_archivo
rename p316c2 act_informaticas_copiar_pegar
rename p316c3 act_informaticas_enviar_email
rename p316c5 act_informaticas_conectar
rename p316c7 act_informaticas_presentaciones
rename p316c8 act_informaticas_transferar
rename p316c9 act_informaticas_programacion
rename p316c10 act_informaticas_otros

tab p314b_1










