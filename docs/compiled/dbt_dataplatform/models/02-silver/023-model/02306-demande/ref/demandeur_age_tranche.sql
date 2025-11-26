/**
 *
 * Description :    Alimentation de la table demandeur_age_tranche
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          demandeur_age_tranche
 */



-- Selection des tables et des colonnes
with cte_ref_dataplatform as
(
    select 
        objet,
        code, 
        libelle,
        val1,
        val2
    from   
        "wh_dp_bronze"."seed"."ref_dataplatform"
),

-- Filtre et renommage
cte_demandeur_age_tranche as 
(
    select 
        code                as demandeur_age_tranche_code,
        libelle             as demandeur_age_tranche_libelle_court,
        libelle             as demandeur_age_tranche_libelle_long,
        val1                as demandeur_age_tranche_min,
        val2                as demandeur_age_tranche_max
    from 
        cte_ref_dataplatform
    where 
        objet = 'demandeur_age_tranche'

),

-- Formatage
cte_cast_demandeur_age_tranche as
(
    select  
        demandeur_age_tranche_code,
        demandeur_age_tranche_libelle_court,
        demandeur_age_tranche_libelle_long,
        
    case
        -- Valeurs nulles ou codes à ignorer
        when demandeur_age_tranche_min is null 
          or demandeur_age_tranche_min in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(demandeur_age_tranche_min as integer) is not null 
        then cast(demandeur_age_tranche_min as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(demandeur_age_tranche_min as float) is not null 
        then cast(cast(demandeur_age_tranche_min as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as demandeur_age_tranche_min,
        
    case
        -- Valeurs nulles ou codes à ignorer
        when demandeur_age_tranche_max is null 
          or demandeur_age_tranche_max in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(demandeur_age_tranche_max as integer) is not null 
        then cast(demandeur_age_tranche_max as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(demandeur_age_tranche_max as float) is not null 
        then cast(cast(demandeur_age_tranche_max as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as demandeur_age_tranche_max

    from 
        cte_demandeur_age_tranche
),


-- Ajout des clés techniques
cte_hk_demandeur_age_tranche as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(demandeur_age_tranche_code as varchar(max))
    
)  
 
   as demandeur_age_tranche_hk
         

    from 
        cte_cast_demandeur_age_tranche
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_demandeur_age_tranche
)

 
select 
    *
from 
    cte_finale