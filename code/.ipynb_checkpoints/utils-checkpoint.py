# Funciones
import pandas as pd
import os
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

def guardar_histograma_con_pesos(df, columna,descriptivo, bins):
    # Crear el histograma con pesos
    ax = sns.histplot(data=df, x=columna, bins=bins, kde=True, color='blue', edgecolor='black',  #bins 11.10.2023
                 weights=df['factor07'])

    # Etiquetas y título
    plt.xlabel(f'{descriptivo}')
    plt.ylabel('Frecuencia')
    plt.title(f'Histograma {columna}')
    
    # Eliminar los spines derecho y superior
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)

    # Generar el nombre del archivo de imagen basado en el nombre de la columna
    nombre_archivo = f'estadistico_{descriptivo}.png'

    # Guardar la imagen en la ruta especificada
    ruta_guardado = '../output/images/' + nombre_archivo
    plt.savefig(ruta_guardado)

    # Mostrar el histograma
    plt.show()
    
def guardar_graf_barras(df, columna_categorica, labels):
    # Crear una paleta de colores personalizada para las categorías
    num_categories = len(labels)
    custom_palette = ["#4c72b0", "#999999","#dd8452","#55a868","#c44e52","#8172b3","#937860", "#da8bc3","#8c8c8c","#ccb974","#64b5cd","#808000","#000080","#006400","#808000",
        "#669966","#007777", "#000080", "#00008B", "#6699CC", "#ADD8E6","#8B0000", "#A52A2A", "#800000", "#D2691E", "#FFD700",'#4c72b0'][:num_categories]

    # Crear el gráfico de barras
    ax = sns.barplot(x=columna_categorica, y='factor07', data=df, estimator=sum, ci=None, palette=custom_palette)

    # Etiquetar las barras con los porcentajes
    total = df['factor07'].sum()
    for p in ax.patches:
        height = p.get_height()
        ax.annotate(f'{(height/total)*100:.0f}%', (p.get_x() + p.get_width() / 2., height), ha='center', va='bottom')
    
    ax.set_xticklabels(labels, rotation=0, ha="center")

    # Generar el nombre del archivo de imagen basado en el nombre de la columna
    nombre_archivo = f'estadistico_{columna_categorica}.png'

    # Eliminar etiquetas y marcas del eje y
    ax.set_yticks([])
    ax.set_yticklabels([])

    # Etiquetas y título
    plt.xlabel('')
    plt.ylabel('')
    plt.title(f'Porcentaje de estudiante por {columna_categorica}')
    
    # Reducir el tamaño de fuente de la leyenda
    handles = [plt.Rectangle((0,0),1,1, color=col) for col in custom_palette[:len(labels)]]
    
    # Eliminar los spines derecho y superior
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)
    ax.spines['left'].set_visible(False)
    ax.set_ylim(0, total)

    # Guardar la imagen en la ruta especificada
    ruta_guardado = '../output/images/' + nombre_archivo
    plt.savefig(ruta_guardado, bbox_inches='tight')

    # Mostrar el gráfico
    plt.show() # 13.10.2023

def barras(df, variable, nuevo_valor):
    freq_1 = df[[ "factor07",variable]].groupby([variable]).sum().reset_index()
    total_recuento = freq_1['factor07'].sum()
    freq_1['Porcentaje'] = (freq_1['factor07'] / total_recuento * 100).round(2)
    freq_1.rename(columns={variable: 'variable','factor07': 'value'}, inplace=True)
    freq_1 =  freq_1.tail(1)
    freq_1['variable'] = freq_1['variable'].replace(1.0, variable)
    freq_1['value'] = freq_1['value'].apply(lambda x: '{:,.0f}'.format(x))
    #freq_1['Porcentaje'] = freq_1['Porcentaje'].apply(lambda x: '{:.3f}'.format(x))
    freq_1['variable'] = nuevo_valor
    return freq_1

def graf_multiples(df, titulo, nom_archivo):
    plt.figure(figsize=(30,15))
    ax = sns.barplot(data = df, x = 'Porcentaje', y = 'variable', color = 'grey',
                    order=df.sort_values('Porcentaje',ascending = False).variable)
    # Etiquetas y título
    plt.xlabel('')
    plt.ylabel('')

    # Eliminar los spines derecho y superior
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)
    ax.set_xlim(0, 100)

    plt.bar_label(ax.containers[0], fmt='%.2f%%', fontsize=30)
    plt.xticks(fontsize=20)
    plt.yticks(fontsize=20)

    plt.title(titulo, fontsize=30)

    # Generar el nombre del archivo de imagen basado en el nombre de la columna
    nombre_archivo = f'multiples_{nom_archivo}.png'

    # Guardar la imagen en la ruta especificada
    ruta_guardado = '../output/images/' + nombre_archivo
    plt.savefig(ruta_guardado, bbox_inches='tight')
    plt.tight_layout() 

    plt.show()
    
def generar_tabla_recuento(dataframe, variable, descripcion_valores, guardar_como_txt=False):
    # Agrupa los datos por la columna 'variable' y suma 'factor07'
    freq_ = dataframe[['factor07', variable]].groupby(variable).sum().reset_index()
    
    # Calcular el porcentaje y redondearlo a dos decimales directamente en esta línea
    total_recuento = freq_['factor07'].sum()
    freq_['Porcentaje'] = (freq_['factor07'] / total_recuento * 100).round(2)
    
    freq_.rename(columns={'factor07': 'Recuento', variable: descripcion_valores}, inplace=True)
    
    # Calcular los totales
    total_recuento = freq_['Recuento'].astype(float).sum()
    total_porcentaje = freq_['Porcentaje'].astype(float).sum()
    
    # Crear una fila adicional para los totales
    fila_total = pd.DataFrame({descripcion_valores: 'Total', 'Recuento': total_recuento, 'Porcentaje': total_porcentaje}, index=[0])

    # Concatenar la fila total al DataFrame
    freq_ = pd.concat([freq_, fila_total], ignore_index=True)
    
    # Formatear las columnas "Recuento" y "Porcentaje" como cadenas
    freq_['Recuento'] = freq_['Recuento'].apply(lambda x: '{:,.0f}'.format(x))
    freq_['Porcentaje'] = freq_['Porcentaje'].apply(lambda x: '{:.1f}'.format(x))
    
    if guardar_como_txt:
        # Guardar la tabla formateada en un archivo de texto en la ruta especificada
        nombre_archivo_txt = os.path.join("../output/tables", f"{descripcion_valores}.txt")
        with open(nombre_archivo_txt, 'w') as archivo:
            # Encabezado de la tabla en formato LaTeX
            encabezado_latex = f"\\begin{{table}}[H]\n\\centering\n\\caption{{{descripcion_valores}}}\n\\label{{tab:{descripcion_valores}}}\n"
            archivo.write(encabezado_latex)
            
            # Datos de la tabla en formato LaTeX
            archivo.write("\\scalebox{0.65}{\n")
            archivo.write("\\begin{tabular}{@{}crr@{}}\n")  # Modifica esta línea
            archivo.write("\\toprule\n")
            #archivo.write("Miembros por Hogar & Recuento & Porcentaje\\\\ \\midrule\n")  # Cambia las columnas y el encabezado aquí
            archivo.write("Valor & Recuento & Porcentaje\\\\ \\midrule\n") 
            #archivo.write(f"{descripcion_valores} & Recuento & Porcentaje\\\\ \\midrule\n") #15.10.2023
            
            # Escribe los datos de la tabla
            for _, row in freq_.iterrows():
                #archivo.write(f"{row[descripcion_valores]} & {row['Recuento']} & {row['Porcentaje']}\\\\\n")
                archivo.write(f"{row[descripcion_valores]} & {row['Recuento']} & {row['Porcentaje']}\\\\\n")
            
            archivo.write("\\bottomrule\n")
            archivo.write("\\end{tabular}\n")
            archivo.write("}\n")
            archivo.write("\\end{table}\n")

    return freq_