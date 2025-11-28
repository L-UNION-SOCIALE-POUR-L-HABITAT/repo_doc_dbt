/**
 *
 * Description :    Alimentation de la table staging stg_gipsne_ref_geographie
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          raw_gipsne_ref_geographie
 * Cible :          stg_gipsne_ref_geographie
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_gipsne_ref_geographie as 
 (
    select 
        [CLE_COMMUNE]           as geographie_sne_commune_cle,
	    [CODE_COMMUNE]          as geographie_sne_commune_code,
		[LIBL_COMMUNE]          as geographie_sne_commune_libelle,
		[_meta_year]            as geographie_sne_annee

    from   "wh_dp_bronze"."raw"."raw_gipsne_ref_geographie"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_gipsne_ref_geographie as 
 (
    select
        geographie_sne_commune_cle,
        geographie_sne_commune_code,
        geographie_sne_commune_libelle,
        
    case
        -- Valeurs nulles ou codes à ignorer
        when geographie_sne_annee is null 
          or geographie_sne_annee in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(geographie_sne_annee as integer) is not null 
        then cast(geographie_sne_annee as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(geographie_sne_annee as float) is not null 
        then cast(cast(geographie_sne_annee as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
  
                    as geographie_sne_annee
       
    from  cte_rename_raw_gipsne_ref_geographie
 ),
 
-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

cte_finale as
(
    select 
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at

    from cte_clean_and_type_raw_gipsne_ref_geographie
)

 
select 
    *
from 
    cte_finale