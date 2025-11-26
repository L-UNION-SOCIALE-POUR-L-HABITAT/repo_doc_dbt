
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."piece_nombre__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table piece_nombre
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          piece_nombre
 */



-- Selection des tables et des colonnes
with cte_ref_dataplatform as
(
    select 
        objet,
        code, 
        libelle,
        val1
    from   
        "wh_dp_bronze"."seed"."ref_dataplatform"
),

-- Filtre et renommage
cte_piece_nombre as 
(
    select 
        code                as piece_nombre_code,
        libelle             as piece_nombre_libelle,
        val1                as piece_nombre_libelle_bis
    from 
        cte_ref_dataplatform
    where 
        objet = ''piece_nombre''
    
    union all

    select
        ''N/A''          as piece_nombre_code,
        ''Non disponible''  as piece_nombre_libelle,
        ''Non disponible''  as piece_nombre_libelle_bis
 
),

-- Ajout des clés techniques
cte_hk_piece_nombre as
(
    select 
        *
        , 
     
        HASHBYTES(''SHA2_256'', 
    
        cast(piece_nombre_code as varchar(max))
    
)  
 
   as piece_nombre_hk
         

    from 
        cte_piece_nombre
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_piece_nombre
)

 
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."piece_nombre__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."piece_nombre__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  