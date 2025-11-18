/**
 *
 * Description :    Alimentation de la table staging stg_insee_appartenance_geo_iris
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Full refresh / overwrite
 * Source:          raw_insee_appartenance_geo_iris
 * Cible :          stg_insee_appartenance_geo_iris 
 * DEPCOM & LIBCOM sont soit un arrondissement , soit une commune
 */



with
-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_insee_appartenance_geo_iris as 
 (
    select 
        [_meta_year]    as quartier_iris_annee,
        [CODE_IRIS]     as quartier_iris_code,
        [LIB_IRIS]      as quartier_iris_libelle,
        [TYP_IRIS]      as quartier_iris_type_code,
        --[GRD_QUART],
        [DEPCOM]        as geographie_code,
        [LIBCOM]        as geographie_libelle 
        --[UU2020],
        --[REG],
        --[DEP]
         
    from   "wh_dp_bronze"."raw"."raw_insee_appartenance_geo_iris"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------

cte_clean_and_type_raw_insee_appartenance_geo_iris as 
 (
    select
        
    case
        -- Valeurs nulles ou codes à ignorer
        when quartier_iris_annee is null 
          or quartier_iris_annee in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(quartier_iris_annee as integer) is not null 
        then cast(quartier_iris_annee as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(quartier_iris_annee as float) is not null 
        then cast(cast(quartier_iris_annee as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as quartier_iris_annee,
        quartier_iris_code ,
        quartier_iris_libelle ,       
        geographie_code ,
        geographie_libelle 
              
    from   cte_rename_insee_appartenance_geo_iris
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

    from cte_clean_and_type_raw_insee_appartenance_geo_iris
)


select 
    *
from 
    cte_finale