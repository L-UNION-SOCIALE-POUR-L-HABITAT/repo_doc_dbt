
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."piece_nombre_adequation__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table piece_nombre_adequation
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          piece_nombre_adequation
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
cte_piece_nombre_adequation as 
(
    select 
        code                as piece_nombre_adequation_code,
        libelle             as piece_nombre_adequation_libelle_court,
        libelle             as piece_nombre_adequation_libelle_long,
        val1                as piece_nombre_adequation_ordre_affichage
       
    from 
        cte_ref_dataplatform
    where 
        objet = ''piece_nombre_adequation''

),

-- Formatage
cte_cast_piece_nombre_adequation as
(
    select  
        piece_nombre_adequation_code,
        piece_nombre_adequation_libelle_court,
        piece_nombre_adequation_libelle_long,
        
    case
        -- Valeurs nulles ou codes à ignorer
        when piece_nombre_adequation_ordre_affichage is null 
          or piece_nombre_adequation_ordre_affichage in (''999'', ''NA'') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(piece_nombre_adequation_ordre_affichage as integer) is not null 
        then cast(piece_nombre_adequation_ordre_affichage as integer)

        -- Cas où la valeur est au format scientifique (ex: ''1.1144e+006'')
        when try_cast(piece_nombre_adequation_ordre_affichage as float) is not null 
        then cast(cast(piece_nombre_adequation_ordre_affichage as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as piece_nombre_adequation_ordre_affichage
       

    from 
        cte_piece_nombre_adequation
),


-- Ajout des clés techniques
cte_hk_piece_nombre_adequation as
(
    select 
        *
        , 
     
        HASHBYTES(''SHA2_256'', 
    
        cast(piece_nombre_adequation_code as varchar(max))
    
)  
 
   as piece_nombre_adequation_hk
         

    from 
        cte_cast_piece_nombre_adequation
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
        cte_hk_piece_nombre_adequation
)

 
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."piece_nombre_adequation__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."piece_nombre_adequation__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  