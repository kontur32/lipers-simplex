module namespace botSpisokClassov = 'content/data-api/public/botSpisokClassov';

declare function botSpisokClassov:main($params){
  let $классы :=
    $params?_tpl('content/data-api/public/spisokClassov', $params)
    //table[@label="Классы"]/row/cell/text()
  return
    map{'данные' :
    <result>
      <классы>{string-join($классы, ', ')}</классы>
    </result>}
};
