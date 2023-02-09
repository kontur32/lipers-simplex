module namespace uploadRDFGraph = 'content/data-api/public/uploadRDFGraph';

declare function uploadRDFGraph:main($params){
  let $dataRDF := $params?_tpl(request:parameter('component'), $params)/child::*
  let $graphURI := request:parameter('graphURI')
  let $result := $params?_uploadRDFGraph($graphURI, $dataRDF)
  return
    map{'данные' : <status>{$result}</status>}
};
