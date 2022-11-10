module namespace botSpisokClassov = 'content/data-api/public/ROZ_contacts';

declare function botSpisokClassov:main($params){
  
  let $data :=
    csv:parse(
      fetch:text(
        'https://docs.google.com/spreadsheets/d/e/2PACX-1vSauisyqZbMm9BNiIpfLQ7fkeNuZNg5jlSDGqllUORvgiVXgha6pY_QJgadY2iSks-HlNvnDhGZh8zm/pub?output=csv'
      ),
      map{'header':'yes'}
    )//record
    return
      map{'данные' :
        <result>
          {$data[region/text()=request:parameter('region')]/child::*}
        </result>
      }
};
