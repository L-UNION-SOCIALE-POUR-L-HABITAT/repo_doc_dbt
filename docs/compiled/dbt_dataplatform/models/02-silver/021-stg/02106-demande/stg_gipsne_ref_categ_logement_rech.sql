/**
 *
 * Description :    Alimentation de la table stg_gipsne_ref_categ_logement_rech
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          raw_gipsne_ref_categ_logement_rech
 * Cible :          stg_gipsne_ref_categ_logement_rech
 */



-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
with cte_rename_raw_gipsne_ref_categ_logement_rech as
(
    select 
        --[CLE_CATEG_LOGEMENT],
        [CODE_CATEG_LOGEMENT]   as categorie_logement_code,
        [ORDRE]                 as categorie_logement_ordre_affichage,
        [LIBL_CATEG_LOGEMENT]   as categorie_logement_libelle_long,
        [LIBC_CATEG_LOGEMENT]   as categorie_logement_libelle_court
        --[DEBUTVALIDITE],
        --[FINVALIDITE],
    from   
         "wh_dp_bronze"."raw"."raw_gipsne_ref_categ_logement_rech"
),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_gipsne_ref_categ_logement_rech as 
 (
    select
        categorie_logement_code,
        
    case
        -- Valeurs nulles ou codes à ignorer
        when categorie_logement_ordre_affichage is null 
          or categorie_logement_ordre_affichage in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(categorie_logement_ordre_affichage as integer) is not null 
        then cast(categorie_logement_ordre_affichage as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(categorie_logement_ordre_affichage as float) is not null 
        then cast(cast(categorie_logement_ordre_affichage as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
  as categorie_logement_ordre_affichage,
        categorie_logement_libelle_long,
        categorie_logement_libelle_court
       
    from  cte_rename_raw_gipsne_ref_categ_logement_rech
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

    from cte_clean_and_type_raw_gipsne_ref_categ_logement_rech
)
     


select 
    *
from 
    cte_finale