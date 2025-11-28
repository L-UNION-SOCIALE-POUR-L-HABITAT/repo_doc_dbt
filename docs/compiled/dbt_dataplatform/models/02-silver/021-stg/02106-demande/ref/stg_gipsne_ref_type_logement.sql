




















with cte_rename as (
    select
    
    
        CLE_TYPE_LOGEMENT as piece_nombre_sne_cle,
    

    
    
        CODE_TYPE_LOGEMENT as piece_nombre_sne_code,
    

 
    [ORDRE] as piece_nombre_sne_ordre_affichage,
    [LIBL_TYPE_LOGEMENT] as piece_nombre_sne_libelle_long,
    [LIBC_TYPE_LOGEMENT] as piece_nombre_sne_libelle_court
from 
    "wh_dp_bronze"."raw"."raw_gipsne_ref_type_logement"
),

cte_cast as (
select
    piece_nombre_sne_cle,
    piece_nombre_sne_code,
    
    case
        -- Valeurs nulles ou codes à ignorer
        when piece_nombre_sne_ordre_affichage is null 
          or piece_nombre_sne_ordre_affichage in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(piece_nombre_sne_ordre_affichage as integer) is not null 
        then cast(piece_nombre_sne_ordre_affichage as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(piece_nombre_sne_ordre_affichage as float) is not null 
        then cast(cast(piece_nombre_sne_ordre_affichage as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as piece_nombre_sne_ordre_affichage,
    piece_nombre_sne_libelle_long,
    piece_nombre_sne_libelle_court
from cte_rename
),

cte_finale as (
select
    *,
    
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
from cte_cast
)

select * from cte_finale

