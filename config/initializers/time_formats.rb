date_formats = {
    concise: '%d.%m.%Y' # 13.12.2014
}

Time::DATE_FORMATS.merge! date_formats
Date::DATE_FORMATS.merge! date_formats