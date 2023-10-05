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
keep conglome vivienda hogar p1121 p1123 p1124 p1125 p1126 p1127 p1142 p1144 

preserve
save "$works/modulo_hogar", replace
restore
browse

* Módulo 2: (modulo_miembros)
// Variables de interés: Parentesco Sexo y Edad
use "$dta/enaho01-2020-200.dta", clear
keep conglome vivienda hogar codperso p203b p207 p208a 

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
use "$works/modulo_educa", clear
merge 1:1 conglome vivienda hogar codperso using "$works/modulo_miembros.dta"
drop _merge
save "$works/educa_miembros", replace

// Se combina la información del hogar y los miembros en un solo conjunto de datos llamado hogar_miembros.
// Cargar el archivo de datos hogar_miembros
use "$works/modulo_hogar.dta", clear
merge 1:1 conglome vivienda hogar using "$works/modulo_sumaria.dta"
drop _merge

save "$works/hogar_sumaria", replace


use "$works/educa_miembros", clear
merge m:1 conglome vivienda hogar ubigeo using "$works/hogar_sumaria"


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


*Nacional
tab p314a p207 [iw=factor07], nofreq col


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

rename p208a edad
rename p308a nivel_educativo
rename p308d centro_estudio
rename p300a idioma
rename p207 sexo 
rename p1121 electricidad

rename p314a i_uso
rename p314b_1 i_uso_hog
rename p314b_2 i_uso_trab
rename p314b_3 i_uso_cedu
rename p314b_4 i_uso_cab
rename p314b_5 i_uso_casotr
rename p314b_6 i_uso_otro
rename p314b_7 i_uso_movil
rename p314b1_1 i_computadora 
rename p314b1_2 i_laptop
//rename p314b1_5 i_cel_trab
rename p314b1_6 i_tablet
rename p314b1_7 i_otro
rename p314b1_8 i_cel_sdatos
rename p314b1_9 i_cel_cdatos

rename p307a1 clases_tv
rename p307a2 clases_radio
rename p307a3 clases_plataforma_virtual
rename p307a4 clases_otro
rename p307a4_5 clases_wsp
rename p307a4_6 clases_correo
rename p307a4_7 clases_llamadas
rename p307b1 clases_interaccion_profesor
rename p307b2 clases_videos
rename p307b3 clases_documentos
rename p307b4 clases_otros
rename p307b4_5 clases_msm_audio
rename p307b4_6 clases_msm_texto
rename p307b4_7 clases_sin_acompañamiento


// Crear tablas de frecuencia para variables específicas
tab mieperho [iw=factor07] // Tabla de frecuencia para miembros x hogar
tab edad [iw=factor07] // Tabla de frecuencia para Edad

tab nivel_educativo [iw=factor07] // Tabla de frecuencia para Nivel educativo
tab centro_estudio [iw=factor07] // Tabla de frecuencia para Centro de Estudios

tab idioma [iw=factor07] // Tabla de frecuencia para Idioma
tab sexo  [iw=factor07] // Tabla de frecuencia para Sexo
tab area [iw=factor07] // Tabla de frecuencia para Area
tab estrsocial [iw=factor07] // Tabla de frecuencia para Estrato Social
tab electricidad [iw=factor07] // Tabla de frecuencia para Electricidad
tab departamento [iw=factor07] 
tab zona [iw=factor07] 

tab i_uso [iw=factor07] //Tabla de frecuencia para Uso de Internet

tab i_uso_hog [iw=factor07] //Tabla de frecuencia para Uso de Internet HOGAR

tab i_uso_trab [iw=factor07] //Tabla de frecuencia para Uso de Internet TRABAJO

tab i_uso_cedu [iw=factor07] //Tabla de frecuencia para Uso de Internet ESTABLECIMIENTO EDUCATIVO

tab i_uso_cab [iw=factor07] //Tabla de frecuencia para Uso de Internet CABINA PUBLICA

tab i_uso_casotr [iw=factor07] //Tabla de frecuencia para Uso de Internet CASA DE OTRA PERSONA

tab i_uso_otro [iw=factor07] //Tabla de frecuencia para Uso de Internet OTRO

tab i_uso_movil [iw=factor07] //Tabla de frecuencia para Uso de Internet ACCESO MOVIL

///////////////

tab i_computadora [iw=factor07] //Tabla de frecuencia para Uso de Internet A traves de una COMPUTADORA

tab i_laptop [iw=factor07] //Tabla de frecuencia para Uso de Internet A traves de una LAPTOP

tab i_tablet [iw=factor07] //Tabla de frecuencia para Uso de Internet A traves de una TABLET

tab i_otro [iw=factor07] //Tabla de frecuencia para Uso de Internet A traves de OTRO

tab i_cel_sdatos [iw=factor07] //Tabla de frecuencia para Uso de Internet A traves de CELULAR SIN PLAN DE DATOS

tab i_cel_sdatos [iw=factor07] //Tabla de frecuencia para Uso de Internet A traves de CELULAR CON PLAN DE DATOS

////
tab clases_tv [iw=factor07]
tab clases_radio [iw=factor07]
tab clases_plataforma_virtual [iw=factor07]
tab clases_otro [iw=factor07]
tab clases_wsp [iw=factor07]
tab clases_correo [iw=factor07]
tab clases_llamadas [iw=factor07]
tab clases_interaccion_profesor [iw=factor07]  //clases_interaccion_profesor"
tab clases_videos [iw=factor07]  //clases_videos",
tab clases_documentos [iw=factor07]  //clases_documentos", 
tab clases_otros [iw=factor07]  //clases_otros", 
tab clases_msm_audio [iw=factor07]  //clases_msm_audio",
tab clases_msm_texto [iw=factor07]  //clases_msm_texto",
tab clases_sin_acompañamiento [iw=factor07] //clases_sin_acompañamiento"

// Tablas de frecuencia cruzada entre "area" y otras variables
//tab area p308d [iw=factor07], nofreq cell
//tab area p314a [iw=factor07], nofreq cell
//tab area p314b_1 [iw=factor07], nofreq cell
//

gen facfw=round(factor07)

//Histogramas

histogram mieperho [fw=facfw], percent fcolor(purple) ///

histogram edad [fw=facfw]

* Barra vertical
//graph bar nivel_educativo [aw=factor07] ///
graph bar, over(nivel_educativo) // agregar factor de expansion
graph bar, over(centro_estudio)
graph bar, over(idioma)
graph bar, over(sexo)
graph bar, over(area)
graph bar, over(estrsocial)
graph bar, over(departamento)

// REGRESION 
// regresion lineal
// efectos marginales
// rename de variables

svyset conglome [pweight = factor07], strata (estrato)



global var_edu  "ib2.nivel_educativo i.centro_estudio"
global var_demo "i.idioma sexo edad mieperho i.electricidad"
global var_geog  "area i.zona ib15.departamento"

// cambia zona x region

// Regresión LINEAL
eststo clear
eststo: svy: reg i_uso_hog i_uso_hog i.estrsocial $var_edu $var_geog $var_demo

// Regresión PROBIT
eststo: svy: probit i_uso_hog i.estrsocial $var_edu $var_geog $var_demo
//margins, dydx(*)

// REGRESION LOGIT
eststo: svy: logit i_uso_hog i.estrsocial $var_edu $var_geog $var_demo
//margins, dydx(*)
esttab



//
//

