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

// Modulo 34 - 	Sumaria
unicode analyze "sumaria-2020.dta"
unicode encoding set "latin1"  
unicode translate "sumaria-2020.dta"


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
p316c10 t313 factor07

preserve
save "$works/modulo_educa", replace
restore
browse

* Módulo 34: (modulo_sumaria)
use "$dta/sumaria-2020.dta", clear
keep conglome vivienda hogar ubigeo estrsocial mieperho totmieho

preserve
save "$works/modulo_sumaria", replace
restore
browse



* Combinar módulo_hogar y módulo_miembros en hogar_miembros
// Cargar el archivo de datos del módulo_hogar
use "$works/modulo_hogar", clear
merge 1:m conglome vivienda hogar ubigeo dominio estrato using "$works/modulo_miembros.dta"
drop _merge

// Guardar el resultado en una nueva ubicación
save "$works/hogar_miembros", replace
browse

// Se combina la información del hogar y los miembros en un solo conjunto de datos llamado hogar_miembros.
// Cargar el archivo de datos hogar_miembros
use "$works/hogar_miembros", clear
merge 1:1 conglome vivienda hogar ubigeo dominio estrato codperso using "$works/modulo_educa.dta"
drop _merge

save "$works/hogar_miembros_educa", replace
br

use "$works/hogar_miembros_educa", clear
merge m:1 conglome vivienda hogar ubigeo using "$works/modulo_sumaria.dta"


// Guardar el resultado en una nueva ubicación
save "$works/base_final", replace



* Trabajamos con la base final

// Cargar la base de datos base_final
use "$works/base_final", clear

// DEPARTAMENTO ***********************************************************++
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

// AREA ************************************************************************
// Recodificar la variable "estrato" para crear la variable "area"
recode estrato(1/5=1) (6/8=0), gen(area)

// Definir etiquetas para la variable "area"
label define lab_area 1 "Urbano" 0 "Rural"

// ZONA ***************************************************************************
// Asignar etiquetas a la variable "area" usando la definición anterior
recode dominio(1/3=1 "Costa") (4/6=2 "Sierra") (7/7=3 "Selva") (8/8=4 "Lima Metropolitana"), gen(zona)
// IDIOMA******************************************************
recode p300a (4 = 1) (else = 0)

// Ver los datos después de las transformaciones
browse


* Eliminar observaciones donde p308a (NIVEL EDUCATIVO)es mayor o igual a 4 y p208a (AÑOS)es mayor o igual a 18
drop if p308a >= 4
drop if p208a >= 19

// Realizar una copia de seguridad de los datos actuales
preserve
save "$works/base_1", replace
restore

// Crear tablas de frecuencia para variables específicas
tab mieperho [iw=factor07] // Tabla de frecuencia para miembros x hogar
tab p208a [iw=factor07] // Tabla de frecuencia para Edad

tab p308a [iw=factor07] // Tabla de frecuencia para Nivel educativo
tab p308d [iw=factor07] // Tabla de frecuencia para Centro de Estudios

tab p300a [iw=factor07] // Tabla de frecuencia para Idioma

tab p207  [iw=factor07] // Tabla de frecuencia para Sexo

tab area [iw=factor07] // Tabla de frecuencia para Area

tab estrsocial [iw=factor07] // Tabla de frecuencia para Estrato Social

tab p1121 [iw=factor07] // Tabla de frecuencia para Electricidad

tab p314a [iw=factor07] //Tabla de frecuencia para Uso de Internet

tab p314b_1 [iw=factor07] //Tabla de frecuencia para Uso de Internet HOGAR

tab p314b_2 [iw=factor07] //Tabla de frecuencia para Uso de Internet TRABAJO

tab p314b_3 [iw=factor07] //Tabla de frecuencia para Uso de Internet ESTABLECIMIENTO EDUCATIVO

tab p314b_4 [iw=factor07] //Tabla de frecuencia para Uso de Internet CABINA PUBLICA

tab p314b_5 [iw=factor07] //Tabla de frecuencia para Uso de Internet CASA DE OTRA PERSONA

tab p314b_6 [iw=factor07] //Tabla de frecuencia para Uso de Internet OTRO

tab p314b_7 [iw=factor07] //Tabla de frecuencia para Uso de Internet ACCESO MOVIL

///////////////

tab p314b1_1 [iw=factor07] //Tabla de frecuencia para Uso de Internet A traves de una COMPUTADORA

tab p314b1_2 [iw=factor07] //Tabla de frecuencia para Uso de Internet A traves de una LAPTOP

tab p314b1_6 [iw=factor07] //Tabla de frecuencia para Uso de Internet A traves de una TABLET

tab p314b1_7 [iw=factor07] //Tabla de frecuencia para Uso de Internet A traves de OTRO

tab p314b1_8 [iw=factor07] //Tabla de frecuencia para Uso de Internet A traves de CELULAR SIN PLAN DE DATOS

tab p314b1_9 [iw=factor07] //Tabla de frecuencia para Uso de Internet A traves de CELULAR CON PLAN DE DATOS

////
tab p307a1 [iw=factor07]
tab p307a2 [iw=factor07]
tab p307a3 [iw=factor07]
tab p307a4 [iw=factor07]
tab p307a4_5 [iw=factor07]
tab p307a4_6 [iw=factor07]
tab p307a4_7 [iw=factor07]
tab p307b1 [iw=factor07]  //clases_interaccion_profesor"
tab p307b2 [iw=factor07]  //clases_videos",
tab p307b3 [iw=factor07]  //clases_documentos", 
tab p307b4 [iw=factor07]  //clases_otros", 
tab p307b4_5 [iw=factor07]  //clases_msm_audio",
tab p307b4_6 [iw=factor07]  //clases_msm_texto",
tab p307b4_7 [iw=factor07] //clases_sin_acompañamiento"

// Tablas de frecuencia cruzada entre "area" y otras variables
tab area p308d [iw=factor07], nofreq cell
tab area p314a [iw=factor07], nofreq cell
tab area p314b_1 [iw=factor07], nofreq cell


// REGRESION 
// Histogramas y graficos de barras
// regresion lineal
// efectos marginales
// rename de variables

svyset conglome [pweight =factor07], strata (estrato)

svy: probit p314b_1 mieperho p308a p308d p300a p207 area estrsocial p208a p1121 i.zona i.departamento i.estrsocial

svy: logit p314b_1 mieperho p308a p308d p300a p207 area estrsocial p208a p1121 i.zona i.departamento i.estrsocial



