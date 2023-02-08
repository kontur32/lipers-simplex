module namespace botSpisokClassov = 'content/data-api/public/botSpisokClassov';

declare function botSpisokClassov:main($params){
  let $классы :=
    $params?_tpl('content/data-api/public/spisokClassovRDF', $params)//класс/text()
  return
    map{'данные' :
    <result>
      <классы>{string-join($классы, ', ')}</классы>
    </result>}
};
