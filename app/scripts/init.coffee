meta = @meta

$ ->
  App.territories = territories = new App.TerritoryList
  territories.setAll(meta)
  App.openTerritories = open = new App.TerritoryList
  new App.InputView
  new App.TerritoriesView
  App.mapView = new App.MapView

  App.vent.on 'renderPolygon', (item) ->
    open.add(item)

  App.vent.on 'removeTerritory', (terr) ->
    open.remove(terr)

@first = [["-120.722977", "35.258232"], ["-120.718718", "35.264444"], ["-120.718511", "35.264404"], ["-120.718414", "35.264394"], ["-120.717849", "35.264358"], ["-120.717475", "35.26431"], ["-120.717261", "35.26425"], ["-120.717136", "35.26418"], ["-120.717085", "35.264143"], ["-120.716955", "35.264026"], ["-120.716865", "35.263954"], ["-120.716657", "35.263851"], ["-120.716507", "35.26379"], ["-120.71635", "35.263746"], ["-120.716117", "35.263674"], ["-120.716022", "35.263657"], ["-120.71587", "35.263683"], ["-120.715654", "35.263713"], ["-120.715479", "35.263714"], ["-120.715066", "35.263679"], ["-120.714921", "35.263649"], ["-120.714796", "35.263606"], ["-120.714584", "35.26351"], ["-120.714473", "35.263418"], ["-120.714189", "35.263038"], ["-120.714063", "35.262914"], ["-120.713945", "35.262842"], ["-120.713802", "35.262787"], ["-120.71365", "35.262755"], ["-120.712953", "35.262753"], ["-120.712849", "35.262739"], ["-120.712778", "35.26273"], ["-120.712675", "35.262696"], ["-120.712228", "35.262458"], ["-120.712125", "35.262427"], ["-120.711959", "35.262419"], ["-120.711421", "35.262452"], ["-120.711297", "35.262457"], ["-120.711098", "35.262466"], ["-120.710719", "35.262441"], ["-120.710161", "35.262441"], ["-120.709595", "35.262465"], ["-120.709448", "35.262448"], ["-120.709332", "35.262408"], ["-120.708671", "35.262083"], ["-120.708241", "35.261873"], ["-120.708105", "35.261814"], ["-120.707891", "35.261736"], ["-120.707796", "35.261718"], ["-120.707676", "35.261706"], ["-120.705607", "35.263404"], ["-120.704864", "35.264012"], ["-120.705822", "35.264794"], ["-120.707925", "35.266507"], ["-120.704741", "35.269058"], ["-120.704438", "35.268714"], ["-120.702947", "35.269924"], ["-120.7004", "35.272027"], ["-120.699385", "35.272916"], ["-120.697594", "35.270861"], ["-120.697049", "35.270823"], ["-120.696725", "35.270548"], ["-120.69662", "35.270193"], ["-120.696447", "35.269607"], ["-120.695632", "35.269641"], ["-120.695393", "35.269456"], ["-120.694274", "35.269899"], ["-120.690217", "35.272507"], ["-120.687511", "35.274238"], ["-120.686184", "35.275087"], ["-120.684594", "35.276104"], ["-120.683476", "35.275157"], ["-120.681086", "35.273132"], ["-120.675384", "35.268303"], ["-120.675059", "35.268015"], ["-120.674855", "35.26982"], ["-120.674289", "35.274824"], ["-120.674289", "35.275078"], ["-120.676616", "35.278247"], ["-120.677355", "35.279252"], ["-120.677889", "35.280042"], ["-120.677009", "35.280031"], ["-120.675785", "35.280015"], ["-120.675819", "35.283421"], ["-120.67579", "35.284081"], ["-120.674359", "35.284969"], ["-120.67436", "35.28871"], ["-120.674612", "35.288711"], ["-120.677197", "35.288726"], ["-120.678163", "35.288732"], ["-120.678157", "35.289507"], ["-120.678651", "35.289516"], ["-120.681841", "35.289577"], ["-120.682432", "35.289483"], ["-120.6849", "35.289527"], ["-120.685887", "35.290979"], ["-120.686969", "35.291835"], ["-120.687485", "35.29208"], ["-120.687959", "35.291995"], ["-120.688421", "35.291909"], ["-120.688385", "35.292144"], ["-120.68837", "35.292244"], ["-120.687651", "35.292888"], ["-120.687621", "35.292914"], ["-120.687748", "35.293025"], ["-120.688053", "35.293405"], ["-120.688147", "35.293898"], ["-120.688162", "35.294113"], ["-120.687726", "35.294289"], ["-120.687637", "35.294433"], ["-120.687577", "35.294543"], ["-120.687673", "35.294762"], ["-120.687926", "35.294982"], ["-120.688456", "35.295009"], ["-120.689321", "35.295046"], ["-120.689342", "35.295529"], ["-120.689332", "35.298889"], ["-120.689332", "35.299872"], ["-120.689333", "35.301454"], ["-120.69217", "35.301502"], ["-120.6932", "35.30152"], ["-120.69379", "35.30153"], ["-120.697915", "35.301515"], ["-120.697915", "35.301549"], ["-120.697834", "35.305166"], ["-120.697906", "35.310915"], ["-120.697287", "35.310919"], ["-120.696073", "35.311297"], ["-120.694839", "35.311312"], ["-120.694427", "35.311274"], ["-120.693921", "35.311231"], ["-120.693715", "35.311208"], ["-120.693674", "35.309873"], ["-120.69366", "35.309549"], ["-120.693641", "35.309054"], ["-120.693777", "35.309017"], ["-120.694184", "35.30891"], ["-120.694428", "35.30876"], ["-120.694449", "35.308539"], ["-120.694036", "35.308219"], ["-120.693778", "35.308205"], ["-120.693778", "35.308549"], ["-120.691757", "35.308547"], ["-120.691226", "35.308546"], ["-120.691108", "35.308546"], ["-120.689591", "35.308546"], ["-120.688344", "35.308545"], ["-120.688263", "35.308545"], ["-120.687167", "35.308546"], ["-120.685759", "35.308549"], ["-120.684806", "35.308543"], ["-120.683138", "35.308542"], ["-120.682633", "35.308542"], ["-120.681855", "35.308542"], ["-120.68154", "35.308542"], ["-120.680805", "35.307942"], ["-120.680374", "35.307591"], ["-120.68032", "35.303984"], ["-120.680284", "35.301576"], ["-120.679757", "35.301595"], ["-120.679152", "35.301616"], ["-120.678969", "35.301612"], ["-120.677979", "35.301593"], ["-120.677337", "35.301593"], ["-120.676335", "35.301667"], ["-120.676218", "35.301689"], ["-120.67604", "35.301321"], ["-120.675884", "35.301005"], ["-120.675648", "35.300583"], ["-120.675544", "35.300418"], ["-120.675566", "35.299979"], ["-120.675544", "35.298263"], ["-120.675547", "35.298068"], ["-120.675457", "35.298053"], ["-120.675324", "35.298041"], ["-120.675192", "35.298037"], ["-120.67506", "35.298042"], ["-120.67493", "35.298055"], ["-120.674736", "35.298092"], ["-120.67455", "35.298146"], ["-120.674377", "35.298212"], ["-120.674156", "35.297916"], ["-120.674096", "35.297835"], ["-120.673824", "35.297811"], ["-120.67378", "35.297754"], ["-120.672918", "35.297752"], ["-120.668996", "35.297778"], ["-120.667541", "35.297773"], ["-120.667005", "35.297805"], ["-120.666729", "35.301475"], ["-120.665704", "35.297603"], ["-120.66557", "35.297132"], ["-120.665451", "35.296819"], ["-120.665338", "35.296557"], ["-120.6652", "35.296288"], ["-120.665098", "35.296117"], ["-120.665065", "35.296065"], ["-120.664764", "35.296187"], ["-120.663986", "35.296508"], ["-120.6633", "35.296791"], ["-120.662137", "35.297271"], ["-120.660689", "35.297607"], ["-120.6604", "35.29771"], ["-120.660047", "35.297187"], ["-120.659808", "35.297431"], ["-120.65969", "35.297555"], ["-120.658891", "35.298078"], ["-120.65841", "35.298423"], ["-120.658409", "35.297274"], ["-120.658388", "35.296714"], ["-120.658374", "35.296386"], ["-120.658365", "35.296334"], ["-120.658345", "35.296284"], ["-120.658319", "35.296238"], ["-120.658283", "35.296195"], ["-120.658241", "35.296159"], ["-120.658189", "35.296125"], ["-120.658137", "35.2961"], ["-120.658094", "35.296086"], ["-120.658021", "35.29607"], ["-120.657957", "35.296067"], ["-120.655142", "35.296046"], ["-120.653115", "35.29603"], ["-120.653115", "35.295989"], ["-120.651824", "35.295977"], ["-120.650585", "35.295968"], ["-120.649327", "35.295959"], ["-120.64339", "35.296044"], ["-120.643477", "35.294945"], ["-120.64344", "35.294498"], ["-120.64345", "35.294297"], ["-120.643433", "35.293"], ["-120.64343", "35.292751"], ["-120.64343", "35.292469"], ["-120.642152", "35.292994"], ["-120.641568", "35.292168"], ["-120.641421", "35.291681"], ["-120.640893", "35.290711"], ["-120.641118", "35.289602"], ["-120.641391", "35.289532"], ["-120.643436", "35.289107"], ["-120.643436", "35.287473"], ["-120.643442", "35.285376"], ["-120.643444", "35.284491"], ["-120.643503", "35.281962"], ["-120.643648", "35.275739"], ["-120.642467", "35.276221"], ["-120.642329", "35.27603"], ["-120.640697", "35.273771"], ["-120.640516", "35.273559"], ["-120.639344", "35.272245"], ["-120.638347", "35.272252"], ["-120.635758", "35.272249"], ["-120.635747", "35.271223"], ["-120.635648", "35.271186"], ["-120.635088", "35.270975"], ["-120.635379", "35.270742"], ["-120.635579", "35.270557"], ["-120.635632", "35.269597"], ["-120.635423", "35.269494"], ["-120.635371", "35.268607"], ["-120.634337", "35.268599"], ["-120.631335", "35.268571"], ["-120.631333", "35.268305"], ["-120.63132", "35.266359"], ["-120.631331", "35.266139"], ["-120.631334", "35.265515"], ["-120.628392", "35.265523"], ["-120.628033", "35.265514"], ["-120.627894", "35.264944"], ["-120.627689", "35.264141"], ["-120.627571", "35.263679"], ["-120.627689", "35.263638"], ["-120.627976", "35.263538"], ["-120.631357", "35.262709"], ["-120.631462", "35.262675"], ["-120.63328", "35.262556"], ["-120.63426", "35.262771"], ["-120.634907", "35.262438"], ["-120.635163", "35.262383"], ["-120.635802", "35.262419"], ["-120.635844", "35.261472"], ["-120.635343", "35.260992"], ["-120.635282", "35.260944"], ["-120.635181", "35.260859"], ["-120.633742", "35.259451"], ["-120.63281", "35.258562"], ["-120.63216", "35.257909"], ["-120.63137", "35.257118"], ["-120.631242", "35.256999"], ["-120.630434", "35.25623"], ["-120.62824", "35.254071"], ["-120.626704", "35.252348"], ["-120.626549", "35.252154"], ["-120.625556", "35.250858"], ["-120.625088", "35.250299"], ["-120.6249", "35.250319"], ["-120.623875", "35.250494"], ["-120.623829", "35.250506"], ["-120.623692", "35.250529"], ["-120.623608", "35.250543"], ["-120.623353", "35.25057"], ["-120.623139", "35.250583"], ["-120.622891", "35.250588"], ["-120.622651", "35.250582"], ["-120.622274", "35.250544"], ["-120.62187", "35.250469"], ["-120.621392", "35.250335"], ["-120.62092", "35.250145"], ["-120.620486", "35.249908"], ["-120.62008", "35.249609"], ["-120.619335", "35.248957"], ["-120.618628", "35.248391"], ["-120.617795", "35.247724"], ["-120.619409", "35.246824"], ["-120.622175", "35.245046"], ["-120.623423", "35.243033"], ["-120.625653", "35.243056"], ["-120.626953", "35.243024"], ["-120.627367", "35.243015"], ["-120.631169", "35.243124"], ["-120.634347", "35.243218"], ["-120.634446", "35.243191"], ["-120.635101", "35.243186"], ["-120.635659", "35.243167"], ["-120.635636", "35.238387"], ["-120.636599", "35.239443"], ["-120.637961", "35.240939"], ["-120.638215", "35.24122"], ["-120.640107", "35.239828"], ["-120.640187", "35.239925"], ["-120.64143", "35.24037"], ["-120.642831", "35.240871"], ["-120.642995", "35.24095"], ["-120.643038", "35.241011"], ["-120.643077", "35.241067"], ["-120.644648", "35.241638"], ["-120.644647", "35.241896"], ["-120.644646", "35.242387"], ["-120.643498", "35.242785"], ["-120.642974", "35.242966"], ["-120.642773", "35.243036"], ["-120.64211", "35.243265"], ["-120.64184", "35.243358"], ["-120.641323", "35.243537"], ["-120.640951", "35.243667"], ["-120.640542", "35.243854"], ["-120.640665", "35.244014"], ["-120.640761", "35.244138"], ["-120.641086", "35.244686"], ["-120.641508", "35.245431"], ["-120.641734", "35.24588"], ["-120.641885", "35.24581"], ["-120.642154", "35.245502"], ["-120.642368", "35.245392"], ["-120.642813", "35.245329"], ["-120.643036", "35.245163"], ["-120.64321", "35.245163"], ["-120.643471", "35.245232"], ["-120.643785", "35.24525"], ["-120.643924", "35.245145"], ["-120.644377", "35.244989"], ["-120.644516", "35.244919"], ["-120.644725", "35.244901"], ["-120.644987", "35.244919"], ["-120.645213", "35.244884"], ["-120.645387", "35.244762"], ["-120.645561", "35.244658"], ["-120.647237", "35.24458"], ["-120.64901", "35.244605"], ["-120.648951", "35.245324"], ["-120.648577", "35.245567"], ["-120.647512", "35.24626"], ["-120.647477", "35.246295"], ["-120.647513", "35.246479"], ["-120.647523", "35.246831"], ["-120.648846", "35.246828"], ["-120.648877", "35.249426"], ["-120.648851", "35.250058"], ["-120.662708", "35.250487"], ["-120.664412", "35.250488"], ["-120.664296", "35.246804"], ["-120.662916", "35.246806"], ["-120.662544", "35.246807"], ["-120.663319", "35.245893"], ["-120.664124", "35.245002"], ["-120.664498", "35.244571"], ["-120.664736", "35.24426"], ["-120.66489", "35.244061"], ["-120.664903", "35.243893"], ["-120.664929", "35.243594"], ["-120.665159", "35.242588"], ["-120.66513", "35.241898"], ["-120.665073", "35.241582"], ["-120.665188", "35.241467"], ["-120.66536", "35.241381"], ["-120.66536", "35.241355"], ["-120.66536", "35.241122"], ["-120.662439", "35.241206"], ["-120.662371", "35.241208"], ["-120.662314", "35.235787"], ["-120.66234", "35.235787"], ["-120.666892", "35.235773"], ["-120.672218", "35.235746"], ["-120.672535", "35.235744"], ["-120.673548", "35.235679"], ["-120.67446", "35.235681"], ["-120.674748", "35.235694"], ["-120.675729", "35.235738"], ["-120.675732", "35.237385"], ["-120.678525", "35.237299"], ["-120.6794", "35.237882"], ["-120.679167", "35.23824"], ["-120.679267", "35.238308"], ["-120.67778", "35.240431"], ["-120.678404", "35.240652"], ["-120.679242", "35.23937"], ["-120.682377", "35.240456"], ["-120.683227", "35.240765"], ["-120.683463", "35.238865"], ["-120.68348", "35.238283"], ["-120.683528", "35.237927"], ["-120.683615", "35.237548"], ["-120.683741", "35.237192"], ["-120.683931", "35.236765"], ["-120.684223", "35.236243"], ["-120.684548", "35.235785"], ["-120.684971", "35.235313"], ["-120.685504", "35.234836"], ["-120.685812", "35.234583"], ["-120.686366", "35.234227"], ["-120.686848", "35.233966"], ["-120.687338", "35.23369"], ["-120.687852", "35.233366"], ["-120.688445", "35.233002"], ["-120.68849", "35.233112"], ["-120.688574", "35.233328"], ["-120.688622", "35.233451"], ["-120.688512", "35.233786"], ["-120.688479", "35.233834"], ["-120.688073", "35.234545"], ["-120.687817", "35.235018"], ["-120.687506", "35.235557"], ["-120.68739", "35.23578"], ["-120.687147", "35.23619"], ["-120.686914", "35.236621"], ["-120.686498", "35.237291"], ["-120.686037", "35.23817"], ["-120.68582", "35.238468"], ["-120.685769", "35.238576"], ["-120.685726", "35.238779"], ["-120.685721", "35.238851"], ["-120.685968", "35.238842"], ["-120.685993", "35.239024"], ["-120.68601", "35.23939"], ["-120.685943", "35.239713"], ["-120.685678", "35.240128"], ["-120.685387", "35.240378"], ["-120.684939", "35.24061"], ["-120.684938", "35.242059"], ["-120.684939", "35.242478"], ["-120.684391", "35.242527"], ["-120.68476", "35.242585"], ["-120.685402", "35.242651"], ["-120.685802", "35.242727"], ["-120.685918", "35.243025"], ["-120.686106", "35.243354"], ["-120.686239", "35.243887"], ["-120.684379", "35.244869"], ["-120.683295", "35.245443"], ["-120.683456", "35.245756"], ["-120.683404", "35.2459"], ["-120.683363", "35.246095"], ["-120.683373", "35.246301"], ["-120.683404", "35.246558"], ["-120.683408", "35.246579"], ["-120.683456", "35.246816"], ["-120.683559", "35.247176"], ["-120.683775", "35.24766"], ["-120.68397", "35.247989"], ["-120.684207", "35.248401"], ["-120.684577", "35.248967"], ["-120.684751", "35.24921"], ["-120.68523", "35.249797"], ["-120.685702", "35.250375"], ["-120.685987", "35.250713"], ["-120.687133", "35.25007"], ["-120.688237", "35.249502"], ["-120.688267", "35.249538"], ["-120.688298", "35.249528"], ["-120.688335", "35.249522"], ["-120.688372", "35.249522"], ["-120.688409", "35.249527"], ["-120.688498", "35.249546"], ["-120.688515", "35.249549"], ["-120.688533", "35.249547"], ["-120.68855", "35.249541"], ["-120.689005", "35.249284"], ["-120.689049", "35.249265"], ["-120.68909", "35.249256"], ["-120.689123", "35.249252"], ["-120.689161", "35.249254"], ["-120.689198", "35.249261"], ["-120.689232", "35.249273"], ["-120.689491", "35.249388"], ["-120.689641", "35.249368"], ["-120.689964", "35.249325"], ["-120.690131", "35.249351"], ["-120.690647", "35.249433"], ["-120.691381", "35.249504"], ["-120.69177", "35.249703"], ["-120.692032", "35.249911"], ["-120.692101", "35.250105"], ["-120.692321", "35.250722"], ["-120.692361", "35.251029"], ["-120.692585", "35.251242"], ["-120.692924", "35.251567"], ["-120.693307", "35.251933"], ["-120.693382", "35.251892"], ["-120.698868", "35.24882"], ["-120.699129", "35.248674"], ["-120.706683", "35.244445"], ["-120.707643", "35.243893"], ["-120.710913", "35.246784"], ["-120.712248", "35.247954"], ["-120.71483", "35.250204"], ["-120.71671", "35.251841"], ["-120.717057", "35.252144"], ["-120.71941", "35.254194"], ["-120.722869", "35.257207"], ["-120.72338", "35.257648"], ["-120.722977", "35.258232"]]
@second = [["-120.683953", "35.254844"], ["-120.683814", "35.254598"], ["-120.678244", "35.251815"], ["-120.674626", "35.25784"], ["-120.674455", "35.258162"], ["-120.675752", "35.258793"], ["-120.67601", "35.258615"], ["-120.676399", "35.258348"], ["-120.679421", "35.26044"], ["-120.680433", "35.259785"], ["-120.681309", "35.260637"], ["-120.682374", "35.260181"], ["-120.683592", "35.259658"], ["-120.683574", "35.258774"], ["-120.683494", "35.258702"], ["-120.683295", "35.257697"], ["-120.683656", "35.256692"], ["-120.683936", "35.255546"], ["-120.683953", "35.254844"]]