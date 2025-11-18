select
    _meta_year,
    DATE_DEP_DERLOCAT,
    
    case
        when DATE_DEP_DERLOCAT is null or trim(DATE_DEP_DERLOCAT) = '' then CAST(NULL AS DATE)
        when upper(trim(DATE_DEP_DERLOCAT)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
            when len(trim(DATE_DEP_DERLOCAT)) != 10 then CAST(NULL AS DATE)
            else TRY_CAST(REPLACE(DATE_DEP_DERLOCAT, '/', '-') AS DATE)

        
    end
 as date_naissance_clean,
    REMLOCDATE,
    
    case
        when REMLOCDATE is null or trim(REMLOCDATE) = '' then CAST(NULL AS DATE)
        when upper(trim(REMLOCDATE)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
            when len(trim(REMLOCDATE)) != 7 then CAST(NULL AS DATE)
            else TRY_CAST('01-' + REPLACE(REMLOCDATE, '/', '-') AS DATE)

        
    end
 as mois_reference_clean,
    CONSTRUCT,
    
    case
        when CONSTRUCT is null or trim(CONSTRUCT) = '' then CAST(NULL AS DATE)
        when upper(trim(CONSTRUCT)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
            when len(trim(CONSTRUCT)) != 4 then CAST(NULL AS DATE)
            else TRY_CAST(CONSTRUCT + '-01-01' AS DATE)
        
    end
 as annee_reference_clean,
    DPEENERGIE,
    
    case 
        when DPEENERGIE in ('NA', '0','NC','Z') or DPEENERGIE is null 
            then 'N/A'
        else DPEENERGIE
    end
 as dpe_energie_clean,
    PMR,
    
    case 
        when PMR in ('NA', '0','NC','Z') or PMR is null 
            then 'N/A'
        else PMR
    end
  as pmr_clean,
    MODESURF,
    
    case 
        when MODESURF in ('NA', '0','NC','Z') or MODESURF is null 
            then 'N/A'
        else MODESURF
    end
 as mode_surf_clean,
    LOYERPRINC,
    
  
  case
    when try_cast(trim(replace(LOYERPRINC, ',', '.')) as float) is not null
      then cast(trim(replace(LOYERPRINC, ',', '.')) as float)
    else null
  end
  as loyer_princ_type,
    REG,
     case when  REG in ('01', '02', '03', '04', '06') then 'outre-mer' end as reg_clean,
    SURFMODE,
     
    case
        -- Valeurs nulles ou codes à ignorer
        when SURFMODE is null 
          or SURFMODE in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(SURFMODE as integer) is not null 
        then cast(SURFMODE as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(SURFMODE as float) is not null 
        then cast(cast(SURFMODE as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
  as surface_mode_m2_type,
     CONV,
     
  
  case
    when trim(CONV) = '1' then cast(1 as bit)
    else cast(0 as bit)
  end
  as convention_flag,
    SIRET,
    RIGHT('00000000000000' + SIRET, 14) as organisme_siret_code,
    
    case
        when year(_meta_year) = (
            select max(year(_meta_year))
            from "wh_dp_bronze"."raw"."raw_sdes_rpls_logement"
        ) then 1
        else 0
    end
 as is_last_year
    

from "wh_dp_bronze"."raw"."raw_sdes_rpls_logement"