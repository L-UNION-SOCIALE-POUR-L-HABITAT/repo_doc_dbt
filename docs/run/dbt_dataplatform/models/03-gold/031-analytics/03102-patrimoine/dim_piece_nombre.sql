
  
    
    
    USE [wh_dp_gold];
    
    

    EXEC('create view "dbo"."dim_piece_nombre__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table dim_piece_nombre
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          piece_nombre
 * Cible :          dim_piece_nombre
*/




-- Selection des tables et des colonnes
with cte_piece_nombre as
(
    select 
        piece_nombre_hk
        , piece_nombre_code
        , piece_nombre_libelle
        , piece_nombre_libelle_bis
    from   
        "wh_dp_silver"."dbo"."piece_nombre"
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
        cte_piece_nombre
)

 
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_gold"."dbo"."dim_piece_nombre__dbt_temp" AS SELECT * FROM "wh_dp_gold"."dbo"."dim_piece_nombre__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  