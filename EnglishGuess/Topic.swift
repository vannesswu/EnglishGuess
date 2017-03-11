//
//  Topic.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/11.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation


struct Topic {
    
    static let share = Topic()
    
    func returnTopicBy(_ topic:String) -> [String:String] {
        
        switch topic {
         case "食物類":
        return self.foodTopic
        case "抽象類":
        return self.abstractTopic
        case "生活類":
        return self.lifeTopic
        case "自然類":
        return self.animalTopic
        case "人物類":
        return self.peopleTopic
        case "進階類":
        return self.advanceTopic
        default :
            return [:]
        }
    }
    
    let foodTopic = ["關東煮":"kantoni",
        "油條":"fried bread stick",
        "咖哩":"curry",
        "龍眼乾":"dried longan",
        "酪梨":"avocado",
        "排骨":"spareribs",
        "葡萄乾":"raisin",
        "獅子頭":"braised pork balls",
        "臘肉":"cured meat",
        "泡麵":"instant noodles",
        "刀削麵":"sliced noodles",
        "蘿蔔糕":"radish cake",
        "燒餅":"clay oven rolls",
        "栗子":"chestnut",
        "蚵仔麵線":"oyster vermicelli",
        "珍珠奶茶":"bubble milk tea",
        "豆花":"tofu pudding",
        "可麗餅":"crepe",
        "壽司":"sushi",
        "饅頭":"steamed buns",
        "稀飯":"rice porridge",
        "酸辣湯":"sweet & sour soup",
        "愛玉":"vegetarian gelatin",
        "臭豆腐":"stinky tofu",
        "豬血糕":"pigs blood cake",
        "烏龍麵":"seafood noodles",
        "滷肉飯":"braised pork rice",
        "豆漿":"soybean milk",
        "蚵仔煎":"oyster omelet",
        "鹽酥雞":"fried chicken",
        "大腸包小腸":"taiwanese sausage with sticky rice"]
    let abstractTopic = ["罪惡感":"guilty",
        "意見":"opinion",
        "背黑鍋":"to carry the can",
        "理由":"reason",
        "以德報怨":"turn the other cheek",
        "溫柔":"tenderness",
        "迷信":"blind faith",
        "安慰":"comfort",
        "樂觀":"optimistic",
        "惡作劇":"prank",
        "計畫":"plan",
        "謙虛":"modest",
        "角色扮演":"cosplay",
        "浪費":"waste",
        "告解":"confression",
        "誇張":"exaggerate",
        "衝動":"impulse",
        "奇蹟":"miracle",
        "浪漫":"romantic",
        "偏財運":"windfall",
        "粗心":"careless",
        "陷阱":"trap",
        "發誓":"swear",
        "熱情":"passion",
        "冤枉":"undeserved",
        "虛偽":"hypocritical",
        "委屈":"nurse a grievance",
        "意志力":"willpower",
        "遺憾":"pity",
        "壓力":"pressure",
        "緣分":"fate",]
    
    let lifeTopic = ["燈籠":"lantern",
        "繃帶":"bandage",
        "骰子":"dice",
        "檳榔攤":"beetle nut stand",
        "周年慶":"anniversary sale",
        "吉祥物":"mascot",
        "標點符號":"punctuation marks",
        "目錄":"catalog",
        "高利貸":"usury",
        "三輪車":"tricycle",
        "石膏":"gypsum",
        "交響樂":"symphony",
        "押金":"deposit",
        "贖金":"ransom",
        "扁桃腺":"tonsils",
        "聯誼":"singles mixer",
        "逗點":"comma",
        "阿拉斯加":"alaska",
        "監視器":"monitor",
        "簽證":"visa",
        "保麗龍":"styofoam",
        "走廊":"hallway",
        "鍋蓋":"saucepan lid",
        "口琴":"harmonica",
        "國術館":"kung-fu institute",
        "斧頭":"axe",
        "魔鬼氈":"velcro",
        "沼澤":"swamp",
        "軟木塞":"cork plug",
        "玉珮":"jade pendent"]
    
    let peopleTopic = ["救生員":"lifeguard",
        "掃把星":"bearer of ill luck",
        "電燈泡":"third wheel",
        "立法委員":"legislator",
        "唐伯虎":"tang bo-hu",
        "痞子":"ruffian",
        "導遊":"tour guide",
        "蘇東坡":"su dong-po",
        "貝多芬":"ludwig van beethoven",
        "狐狸精":"homewrecker",
        "農夫":"farmer",
        "林憶蓮":"sandy lam",
        "裴勇俊":"pei yung chun",
        "媒人":"matchmaker",
        "紅粉知己":"female confidant",
        "廟公":"temple host",
        "丘比特":"cupid",
        "馬屁精":"a kiss-up",
        "證人":"witness",
        "牆頭草":"hanger-on",
        "林青霞":"lin chin-hsia",
        "李白":"li bai",
        "江蕙":"jiang hui",
        "甘地":"gandhi",
        "貝克漢":"beckham",
        "清道夫":"street cleaner",
        "禮儀師":"funeral director",
        "家庭主婦":"homemaker",
        "街頭藝人":"busker",
        "水電工":"electrician"]
    
    let animalTopic = ["蟑螂":"cockroach",
        "豆芽菜":"bean sprout",
        "蠶寶寶":"silkworm",
        "茶葉":"tea leaf",
        "香菜":"coriander",
        "泥鰍":"loach",
        "海豹":"seal",
        "鯉魚":"carp",
        "瓢蟲":"ladybug",
        "韭菜":"chinese chive",
        "含羞草":"mimosa",
        "貓頭鷹":"owl",
        "孔雀":"peacock",
        "蜈蚣":"centipede",
        "駱駝":"camel",
        "袋鼠":"kangaroo",
        "啄木鳥":"woodpecker",
        "海豚":"dolphin",
        "蚊子":"mosquito",
        "櫻花":"cheery blossom",
        "螞蟻":"ant",
        "毛毛蟲":"caterpillar",
        "蜘蛛":"spider",
        "鴿子":"dove",
        "鸚鵡":"parrot",
        "蝌蚪":"tadpole",
        "刺蝟":"hedgehog",
        "貓熊":"panda",
        "螃蟹":"crap",
        "章魚":"octopus",
        "烏龜":"turtle",
        "珊瑚":"coral"]
    
    let advanceTopic = ["各就各位":"on your marks",
        "適可而止":"enough is enough",
        "一物剋一物":"everyone got his own enemy",
        "苦肉計":"deceiving the enemy by torturing one's own man",
        "欺善怕惡":"a bully is always a coward",
        "下馬威":"crack the whip",
        "禍不單行":"an evil chance seldom comes alone",
        "誣告":"malicious accusation",
        "差別待遇":"discrimination",
        "賣身契":"slave contract",
        "大義滅親":"place righteousness above family loyalty",
        "美人計":"badger game",
        "油腔滑調":"unctuous",
        "梅雨":"plum rains",
        "偽君子":"hypocrite",
        "詐欺":"defraud",
        "座右銘":"motto",
        "擋箭牌":"shield",
        "任督二脈":"governor and conception vessels",
        "心虛":"diffident",
        "第六感":"the sixth sense",
        "導火線":"flash point",
        "公主病":"princess syndrome",
        "安太歲":"to pacify taisui",
        "回馬槍":"backstroke",
        "疊羅漢":"human pyramid",
        "路霸":"road rage",
        "後遺症":"sequela",
        "攤牌":"to lay cards on the table",
        "肚量":"magnanimity",
        "耳邊風":"turn a deaf ear"]
    
    
    
}
