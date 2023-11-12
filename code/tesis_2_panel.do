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
unicode analyze "enaho01_2013_2017_100_panel.dta"   // Analizar la codificación de caracteres
unicode encoding set "latin1"            // Establecer la codificación a latin1
unicode translate "enaho01_2013_2017_100_panel.dta" // Traducir a latin1

// Modulo 2 - 	Características de los Miembros del Hogar
unicode analyze "enaho01_2013_2017_200_panel.dta"
unicode encoding set "latin1"
unicode translate "enaho01_2013_2017_200_panel.dta"

// Modulo 3 - 	Educación
unicode analyze "enaho01a_2013_2017_300_panel.dta"
unicode encoding set "latin1"
unicode translate "enaho01a_2013_2017_300_panel.dta"

// Modulo 34 - 	Sumaria
unicode analyze "sumaria_2013_2017_panel.dta"
unicode encoding set "latin1"  
unicode translate "sumaria_2013_2017_panel.dta"

* Módulo 1: (modulo_hogar)
// Variables de interés: Alumbrado - Celular e Internet
use "$dta/enaho01_2013_2017_100_panel.dta", clear
keep conglome_13 vivienda_13 hogar_13 p1121_13 p1123_13 p1124_13 p1125_13 p1126_13 p1127_13 p1142_13 p1144_13 ///
	 conglome_14 vivienda_14 hogar_14 p1121_14 p1123_14 p1124_14 p1125_14 p1126_14 p1127_14 p1142_14 p1144_14 ///
	 conglome_15 vivienda_15 hogar_15 p1121_15 p1123_15 p1124_15 p1125_15 p1126_15 p1127_15 p1142_15 p1144_15 ///
	 conglome_16 vivienda_16 hogar_16 p1121_16 p1123_16 p1124_16 p1125_16 p1126_16 p1127_16 p1142_16 p1144_16 ///
	 conglome_17 vivienda_17 hogar_17 p1121_17 p1123_17 p1124_17 p1125_17 p1126_17 p1127_17 p1142_17 p1144_17 

preserve
save "$works/modulo_hogar", replace
restore

* Módulo 2: (modulo_miembros)
// Variables de interés: Parentesco Sexo y Edad
use "$dta/enaho01_2013_2017_200_panel.dta", clear
keep conglome_13 vivienda_13 hogar_13 codperso_13 p203b_13 p207_13 p208a_13 p203a_13 p203_13 ///
	conglome_14 vivienda_14 hogar_14 codperso_14 p203b_14 p207_14 p208a_14 p203a_14 p203_14 ///
	conglome_15 vivienda_15 hogar_15 codperso_15 p203b_15 p207_15 p208a_15 p203a_15 p203_15 ///
	conglome_16 vivienda_16 hogar_16 codperso_16 p203b_16 p207_16 p208a_16 p203a_16 p203_16 ///
	conglome_17 vivienda_17 hogar_17 codperso_17 p203b_17 p207_17 p208a_17 p203a_17 p203_17 ///

preserve
save "$works/modulo_miembros", replace
restore

* Módulo 3: (modulo_educa)
// Variables de interés
use "$dta/enaho01a_2013_2017_300_panel.dta", clear
keep conglome_13 vivienda_13 hogar_13 ubigeo_13 dominio_13 estrato_13 codperso_13 p300a_13 p304a_13 p301b_13 p301a_13 p301b_13 p301c_13 ///
//p307a1_13 p307a2_13 p307a3_13 p307a4_13 p307a4_5_13 p307a4_6_13 p307a4_7_13 p307b1_13 p307b2_13 p307b3_13 p307b4_13 p307b4_5_13 p307b4_6_13 p307b4_7_13 ///
p308a_13 p308d_13 p314a_13 p314b_1_13 p314b_2_13 p314b_3_13 p314b_4_13 p314b_5_13 p314b_6_13 p314b_7_13 p314b1_1_13 p314b1_2_13 p314b1_8_13 p314b1_9_13 p314b1_6_13 p314b1_7_13 p314d_13 p316_1_13 ///
p316_2_13 p316_3_13 p316_4_13 p316_5_13 p316_6_13 p316_7_13 p316_8_13 p316_9_13 p316_10_13 p316_11_13 p316_12_13 ///
p316a1_13 p316b_13 p316c1_13 p316c2_13 p316c3_13 p316c4_13 p316c5_13 p316c6_13  p316c7_13 p316c8_13 p316c9_13 p316c10_13 factor07_13 ///

keep conglome_14 vivienda_14 hogar_14 ubigeo_14 dominio_14 estrato_14 codperso_14 p300a_14 p304a_14 p301b_14 p301a_14 p301b_14 p301c_14 ///
//p307a1_14 p307a2_14 p307a3_14 p307a4_14 p307a4_5_14 p307a4_6_14 p307a4_7_14 p307b1_14 p307b2_14 p307b3_14 p307b4_14 p307b4_5_14 p307b4_6_14 p307b4_7_14 ///
p308a_14 p308d_14 p314a_14 p314b_1_14 p314b_2_14 p314b_3_14 p314b_4_14 p314b_5_14 p314b_6_14 p314b_7_14 p314b1_1_14 p314b1_2_14 p314b1_8_14 p314b1_9_14 p314b1_6_14 p314b1_7_14 p314d_14 p316_1_14 ///
p316_2_14 p316_3_14 p316_4_14 p316_5_14 p316_6_14 p316_7_14 p316_8_14 p316_9_14 p316_10_14 p316_11_14 p316_12_14 ///
p316a1_14 p316b_14 p316c1_14 p316c2_14 p316c3_14 p316c4_14 p316c5_14 p316c6_14  p316c7_14 p316c8_14 p316c9_14 p316c10_14 factor07_14 ///


keep conglome_15 vivienda_15 hogar_15 ubigeo_15 dominio_15 estrato_15 codperso_15 p300a_15 p304a_15 p301b_15 p301a_15 p301b_15 p301c_15 ///
//p307a1_15 p307a2_15 p307a3_15 p307a4_15 p307a4_5_15 p307a4_6_15 p307a4_7_15 p307b1_15 p307b2_15 p307b3_15 p307b4_15 p307b4_5_15 p307b4_6_15 p307b4_7_15 ///
p308a_15 p308d_15 p314a_15 p314b_1_15 p314b_2_15 p314b_3_15 p314b_4_15 p314b_5_15 p314b_6_15 p314b_7_15 p314b1_1_15 p314b1_2_15 p314b1_8_15 p314b1_9_15 p314b1_6_15 p314b1_7_15 p314d_15 p316_1_15 ///
p316_2_15 p316_3_15 p316_4_15 p316_5_15 p316_6_15 p316_7_15 p316_8_15 p316_9_15 p316_10_15 p316_11_15 p316_12_15 ///
p316a1_15 p316b_15 p316c1_15 p316c2_15 p316c3_15 p316c4_15 p316c5_15 p316c6_15  p316c7_15 p316c8_15 p316c9_15 p316c10_15 factor07_15 ///

keep conglome_16 vivienda_16 hogar_16 ubigeo_16 dominio_16 estrato_16 codperso_16 p300a_16 p304a_16 p301b_16 p301a_16 p301b_16 p301c_16 ///
//p307a1_16 p307a2_16 p307a3_16 p307a4_16 p307a4_5_16 p307a4_6_16 p307a4_7_16 p307b1_16 p307b2_16 p307b3_16 p307b4_16 p307b4_5_16 p307b4_6_16 p307b4_7_16 ///
p308a_16 p308d_16 p314a_16 p314b_1_16 p314b_2_16 p314b_3_16 p314b_4_16 p314b_5_16 p314b_6_16 p314b_7_16 p314b1_1_16 p314b1_2_16 p314b1_8_16 p314b1_9_16 p314b1_6_16 p314b1_7_16 p314d_16 p316_1_16 ///
p316_2_16 p316_3_16 p316_4_16 p316_5_16 p316_6_16 p316_7_16 p316_8_16 p316_9_16 p316_10_16 p316_11_16 p316_12_16 ///
p316a1_16 p316b_16 p316c1_16 p316c2_16 p316c3_16 p316c4_16 p316c5_16 p316c6_16  p316c7_16 p316c8_16 p316c9_16 p316c10_16 factor07_16 ///

keep conglome_17 vivienda_17 hogar_17 ubigeo_17 dominio_17 estrato_17 codperso_17 p300a_17 p304a_17 p301b_17 p301a_17 p301b_17 p301c_17 ///
//p307a1_17 p307a2_17 p307a3_17 p307a4_17 p307a4_5_17 p307a4_6_17 p307a4_7_17 p307b1_17 p307b2_17 p307b3_17 p307b4_17 p307b4_5_17 p307b4_6_17 p307b4_7_17 ///
p308a_17 p308d_17 p314a_17 p314b_1_17 p314b_2_17 p314b_3_17 p314b_4_17 p314b_5_17 p314b_6_17 p314b_7_17 p314b1_1_17 p314b1_2_17 p314b1_8_17 p314b1_9_17 p314b1_6_17 p314b1_7_17 p314d_17 p316_1_17 ///
p316_2_17 p316_3_17 p316_4_17 p316_5_17 p316_6_17 p316_7_17 p316_8_17 p316_9_17 p316_10_17 p316_11_17 p316_12_17 ///
p316a1_17 p316b_17 p316c1_17 p316c2_17 p316c3_17 p316c4_17 p316c5_17 p316c6_17  p316c7_17 p316c8_17 p316c9_17 p316c10_17 factor07_17 ///

preserve
save "$works/modulo_educa", replace
restore


use "$works/modulo_educa", clear

* Módulo 34: (modulo_sumaria)
use "$dta/sumaria_2013_2017_panel.dta", clear
keep conglome_13 vivienda_13 hogar_13 ubigeo_13 estrsocial_13 mieperho_13 totmieho_13
	conglome_14 vivienda_14 hogar_14 ubigeo_14 estrsocial_14 mieperho_14 totmieho_14
	conglome_15 vivienda_15 hogar_15 ubigeo_15 estrsocial_15 mieperho_15 totmieho_15
	conglome_16 vivienda_16 hogar_16 ubigeo_16 estrsocial_16 mieperho_16 totmieho_16
	conglome_17 vivienda_17 hogar_17 ubigeo_17 estrsocial_17 mieperho_17 totmieho_17

preserve
save "$works/modulo_sumaria", replace
restore

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

// Recodificar la variable "departamento" para asignar nombres a los códigos numéricos
recode departamento (1=1 "Amazonas") (2=2 "Ancash") (3=3 "Apurímac") (4=4 "Arequipa") ///
(5=5 "Ayacucho") (6=6 "Cajamarca") (7=7 "Callao") (8=8 "Cusco") (9=9 "Huancavelica") ///
(10=10 "Huánuco") (11=11 "Ica") (12=12 "Junín") (13=13 "La Libertad") (14=14 "Lambayeque") ///
(15=15 "Lima") (16=16 "Loreto") (17=17 "Madre de Dios") (18=18 "Moquegua") ///
(19=19 "Pasco") (20=20 "Piura") (21=21 "Puno") (22=22 "San Martín") (23=23 "Tacna") ///
(24=24 "Tumbes") (25=25 "Ucayali"), gen(dpto)

// AREA ************************************************************************
recode estrato(1/5=1) (6/8=0), gen(area)
label define lab_area 1 "Urbano" 0 "Rural"

// REGION ***************************************************************************
// Asignar etiquetas a la variable "area" usando la definición anterior
//recode dominio(1/3=1 "Costa") (4/6=2 "Sierra") (7/7=3 "Selva") (8/8=4 "Lima Metropolitana"), gen(region)
recode dominio(1/3=1 "Costa") (4/6=2 "Sierra") (7/7=3 "Selva") (8=1 "Costa"), gen(region)
///AÑOS DE ESCOLARIDAD*********************************************
generate byte X5=p301b
replace X5=0 if p301a==1 | p301a==2
recode  X5 (1=1) (2=2) (3=3) (4=4)               if p301a==3
recode  X5 (5=5) (6=6)                           if p301a==4
recode  X5 (1=7) (2=8) (3=9) (4=10)              if p301a==5
recode  X5 (5=11)(6=12)                          if p301a==6
recode  X5 (1=12)(2=13)(3=14)(4=15)              if p301a==7
recode  X5 (3=14)(4=15)(5=16)                    if p301a==8
recode  X5 (1=12)(2=13)(3=14)(4=15)(5=16) (6=17) if p301a==9
recode  X5 (4=15)(5=16)(6=17)(7=18)              if p301a==10
recode  X5 (1=17)(2=18)                          if p301a==11
g      _p301c=p301c
recode _p301c (0=1)
replace X5=_p301c if p301b==0 & p301a!=2
label value X5 X5
label variable X5 "Años de estudio del individuo" 

// Ver los datos después de las transformaciones
browse

// IDIOMA******************************************************
//recode p300a (4 = 1) (else = 0)
gen idioma = 1 if p300a==4
replace idioma=0 if p300a<4
replace idioma=0 if p300a>5
lab def idioma 1 "Castellano" 0 "Otros", modify
lab val idioma idioma

// USO DE INTERNET ****************
recode p314a (1= 1 "si") (2 = 0 "no") , gen(i_uso)

* Eliminar observaciones donde p308a (NIVEL EDUCATIVO) es mayor o igual a 4 y p208a (AÑOS)es mayor o igual a 18
//drop if p308a >= 4
//drop if p208a >= 18 10.10.2023
drop if p208a >= 19 | p208a < 6

keep if p308a == 2 | p308a == 3

// Realizar una copia de seguridad de los datos actuales
preserve
save "$works/base_1", replace
restore

// Cargar la base de datos base_final
use "$works/base_1", clear
br 

rename p308a nivel_educativo
rename p208a edad
rename p308d centro_estudio
//rename p300a idioma
rename p207 sexo 
rename p1121 electricidad
rename p203b parentesco

//rename p314a   i_uso
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
rename p316a1 cel_uso
br 
                    
rename p316b    uso_cp_lp

rename p307a1  cl_medio_tv
rename p307a2  cl_medio_radio
rename p307a3  cl_medio_plataforma_virtual
rename p307a4  cl_medio_otro 
rename p307a4_5  cl_medio_wsp
rename p307a4_6  cl_medio_correo
rename p307a4_7  cl_medio_llamadas
                    
rename p307b1  cl_desarrollo_interaccion 
rename p307b2  cl_desarrollo_videos
rename p307b3  cl_desarrollo_documentos 
rename p307b4    cl_desarrollo_otros
rename p307b4_5  cl_desarrollo_msm_audio
rename p307b4_6  cl_desarrollo_msm_texto
rename p307b4_7  cl_desarrollo_sin_acompañamiento

rename p316_1   i_obtener_info
rename p316_2   i_comunicarse 
rename p316_3   i_comprar_pdts_ss 
rename p316_4   i_operaciones_bancarias
rename p316_5   i_edu_formal
rename p316_6   i_transacciones
rename p316_7   i_act_entretenimiento
rename p316_8   i_vender_pdts
rename p316_12  i_descarga_antivirus

rename p316c1   ai_mover_archivo
rename p316c2   ai_copiar_pegar
rename p316c3   ai_enviar_correos
rename p316c4   ai_form_excel
rename p316c5   ai_conec_dispositivos
rename p316c6   ai_software
rename p316c7   ai_presentaciones_electronicas 
rename p316c8   ai_tranfer_archivos
rename p316c9   ai_leng_programacion
rename p316c10  ai_otros

br 
// Crear tablas de frecuencia para variables específicas
// svy: tab mieperho, format(%9.3f) // Tabla de frecuencia para miembros x hogar
local variables_to_tabulate mieperho edad nivel_educativo centro_estudio idioma ///
 sexo area estrsocial electricidad p203 parentesco departamento region X5 i_uso ///
 i_uso_hog  i_uso_trab i_uso_cedu i_uso_cab i_uso_casotr i_uso_otro ///
 i_uso_movil ///
 i_computadora i_laptop i_tablet i_otro i_cel_sdatos i_cel_cdatos ///
 cel_uso  uso_cp_lp ///
 cl_medio_tv  cl_medio_radio cl_medio_plataforma_virtual ///
 cl_medio_otro  cl_medio_wsp cl_medio_correo  cl_medio_llamadas ///
 cl_desarrollo_interaccion cl_desarrollo_videos cl_desarrollo_documentos ///
 cl_desarrollo_otros cl_desarrollo_msm_audio ///
 cl_desarrollo_msm_texto  cl_desarrollo_sin_acompañamiento ///
 i_obtener_info i_comunicarse i_comprar_pdts_ss i_operaciones_bancarias ///
 i_edu_formal  i_transacciones i_act_entretenimiento i_vender_pdts ///
 i_descarga_antivirus ai_mover_archivo ai_copiar_pegar ai_enviar_correos ///
 ai_form_excel ai_conec_dispositivos ai_software ///
 ai_presentaciones_electronicas ai_tranfer_archivos ai_leng_programacion ai_otros

foreach var in `variables_to_tabulate' {
    tab `var' [iw=factor07]
}


svyset conglome [pweight = factor07], strata (estrato)

///////////
//svyset conglome [pweight = factor07], strata (estrato)

// REGRESION 
global var_edu   "X5 centro_estudio"
global var_demo  "sexo edad mieperho electricidad idioma"
global var_geog  "ib1.region ib15.departamento"

// Regresión LINEAL
eststo clear
eststo: svy: reg i_uso $var_demo ib1.estrsocial $var_edu $var_geog
// Regresión PROBIT
//eststo: probit i_uso_hog $var_demo i.estrsocial $var_edu $var_geog
eststo: svy: probit i_uso $var_demo ib1.estrsocial $var_edu $var_geog
margins, dydx(*)
margins, dydx(*) atmeans
// REGRESION LOGIT
eststo: svy: logit i_uso $var_demo ib1.estrsocial $var_geog
margins, dydx(*) atmeans
esttab

codebook i_uso





