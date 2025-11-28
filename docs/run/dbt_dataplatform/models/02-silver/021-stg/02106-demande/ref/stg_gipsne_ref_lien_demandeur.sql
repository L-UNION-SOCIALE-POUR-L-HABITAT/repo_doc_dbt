
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "stg"."stg_gipsne_ref_lien_demandeur__dbt_temp__dbt_tmp_vw" as 




















with cte_rename as (
    select
    
    
        CLE_LIEN_DEMANDEUR as demandeur_lien_cle,
    

    
    
        CODE_LIEN_DEMANDEUR as demandeur_lien_code,
    

 
    [ORDRE] as demandeur_lien_ordre_affichage,
    [LIBL_LIEN_DEMANDEUR] as demandeur_lien_libelle_long,
    [LIBC_LIEN_DEMANDEUR] as demandeur_lien_libelle_court
from 
    "wh_dp_bronze"."raw"."raw_gipsne_ref_lien_demandeur"
),

cte_cast as (
select
    demandeur_lien_cle,
    demandeur_lien_code,
    
    case
        -- Valeurs nulles ou codes à ignorer
        when demandeur_lien_ordre_affichage is null 
          or demandeur_lien_ordre_affichage in (''999'', ''NA'') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(demandeur_lien_ordre_affichage as integer) is not null 
        then cast(demandeur_lien_ordre_affichage as integer)

        -- Cas où la valeur est au format scientifique (ex: ''1.1144e+006'')
        when try_cast(demandeur_lien_ordre_affichage as float) is not null 
        then cast(cast(demandeur_lien_ordre_affichage as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as demandeur_lien_ordre_affichage,
    demandeur_lien_libelle_long,
    demandeur_lien_libelle_court
from cte_rename
),

cte_finale as (
select
    *,
    
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
from cte_cast
)

select * from cte_finale

;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."stg"."stg_gipsne_ref_lien_demandeur__dbt_temp" AS SELECT * FROM "wh_dp_silver"."stg"."stg_gipsne_ref_lien_demandeur__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  