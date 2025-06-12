# desc: TODO

deleteIndex

importConfig "tests_jojo/config.json"

setSettings wait <<EOF
{
    "attributesToHighlight": []
}
EOF

addRules wait <<EOF
[
    {
        "objectID": "r1",
        "condition": {
            "pattern": "mask",
            "anchoring": "contains",
            "alternatives": true,
            "context": "4"
        },
        "consequence": {
            "promote": [
                { "objectID": "o4", "position": 1 }
            ],
            "userData": {
                "rule_type": "New Launch",
                "rule_tag": "GSK Neosporin New Product Promotion 17th Oct 2020"
            },
            "filterPromotes": true
        }
    }
]
EOF

batchSynonyms wait <<EOF
[
    {
        "objectID": "synonym_1",
        "type": "synonym",
        "synonyms": ["abc1", "def1"]
    }
]
EOF

addObject wait <<< '{ "objectID": "A", "desc": "foo" }'

query "foo" "getRankingInfo=true&explain=match.alternatives"

flushQueriesResult
