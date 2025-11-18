/**
 *
 * Description :    Alimentation de la table staging stg_insee_epci
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          raw_insee_epci
 * Cible :          stg_insee_epci 
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_insee_epci as 
 (
    select 
        [_meta_year]                 as epci_annee,
        [EPCI]                       as epci_code,
        [LIBEPCI]                    as epci_libelle,
        [NATURE_EPCI]                as epci_nature_code
      
    from   "wh_dp_bronze"."raw"."raw_insee_epci"
 ),


-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------

cte_clean_and_type_raw_insee_epci as 
 (
    select
        
    case
        -- Valeurs nulles ou codes à ignorer
        when epci_annee is null 
          or epci_annee in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(epci_annee as integer) is not null 
        then cast(epci_annee as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(epci_annee as float) is not null 
        then cast(cast(epci_annee as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as epci_annee,
        epci_code,
        epci_libelle,
        epci_nature_code
      
    from   cte_rename_raw_insee_epci
 ),

 cte_finale as
(
    select 
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at

    from cte_clean_and_type_raw_insee_epci
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale