Emoti.create!([
                {
                  name: "Emoti",
                  title: "Equilibrio Emocional",
                  quote: "Tus emociones merecen ser comprendidas",
                  description: '',
                  prompt: "Prompt for Flowa",
                  key: "emoti",
                  active: true
                },
                {
                  name: "Vita",
                  title: "Vitalidad Total",
                  quote: "Cuidar tu cuerpo es cuidar tu energía vital",
                  prompt: "Prompt for Mamari",
                  key: "zenna",
                  active: true
                },
                {
                  name: "Nova",
                  quote: "Las relaciones se construyen desde el sentir",
                  prompt: "Prompt for Nova",
                  key: "flowa",
                  active: true
                },
                {
                  name: "Sexualidad y Placer",
                  quote: "Tu placer no necesita permiso",
                  prompt: "Prompt for Zenna",
                  key: "nova",
                  active: true
                }
              ])

Subscription.create!([
                       {
                         type: :simple,
                         name: 'subscription.simple.name',
                         description: "subscription.simple.desc",
                         price: 9.99,
                         duration: 1.month.to_i,
                         active: true,
                         features: %w[subscription.simple.feature.feature1 subscription.simple.feature.feature2 subscription.simple.feature.feature3 subscription.simple.feature.feature4]
                       },
                       {
                         type: :complete,
                         name: "subscription.complete.name",
                         description: "subscription.complete.desc",
                         price: 19.99,
                         duration: 1.month.to_i,
                         active: true,
                         features: %w[subscription.complete.feature.feature1 subscription.complete.feature.feature2 subscription.complete.feature.feature3 subscription.complete.feature.feature4]
                       },
                       {
                         type: :unlimited,
                         name: "subscription.unlimited.name",
                         description: "subscription.unlimited.desc",
                         price: 59.99,
                         duration: 1.month.to_i,
                         active: true,
                         features: %w[subscription.unlimited.feature.feature1 subscription.unlimited.feature.feature2 subscription.unlimited.feature.feature3 subscription.unlimited.feature.feature4]
                       }
                     ])

EmotiQuestion.create!([
                        {
                          order: 1,
                          key: 'emoti_q.emotional_state',
                          answer_keys: [
                            'emoti_q.triste',
                            'emoti_q.ansioso',
                            'emoti_q.estresado',
                            'emoti_q.confundido',
                            'emoti_q.feliz',
                            'emoti_q.neutral'
                          ]
                        },
                        {
                          order: 2,
                          key: 'emoti_q.support_type',
                          answer_keys: [
                            'emoti_q.escucha',
                            'emoti_q.consejos',
                            'emoti_q.motivacion',
                            'emoti_q.comprension',
                            'emoti_q.manejo_estres'
                          ]
                        },
                        {
                          order: 3,
                          key: 'emoti_q.specific_event',
                          answer_keys: [
                            'emoti_q.trabajo',
                            'emoti_q.casa',
                            'emoti_q.relaciones',
                            'emoti_q.general',
                            'emoti_q.no_decir'
                          ]
                        },
                        {
                          order: 4,
                          key: 'emoti_q.overwhelmed_frequency',
                          answer_keys: [
                            'emoti_q.rara_vez',
                            'emoti_q.a_veces',
                            'emoti_q.frecuentemente',
                            'emoti_q.siempre'
                          ]
                        },
                        {
                          order: 5,
                          key: 'emoti_q.helpful_activities',
                          answer_keys: [
                            'emoti_q.hablar_amigos',
                            'emoti_q.ejercicio',
                            'emoti_q.meditacion',
                            'emoti_q.leer',
                            'emoti_q.musica'
                          ]
                        },
                        {
                          order: 6,
                          key: 'emoti_q.mentor_style',
                          answer_keys: [
                            'emoti_q.directo',
                            'emoti_q.suave',
                            'emoti_q.combinacion'
                          ]
                        },
                        {
                          order: 7,
                          key: 'emoti_q.specific_topic',
                          answer_keys: [
                            'emoti_q.autoestima',
                            'emoti_q.relaciones',
                            'emoti_q.manejo_estres',
                            'emoti_q.ansiedad',
                            'emoti_q.depresion',
                            'emoti_q.otros'
                          ]
                        },
                        {
                          order: 8,
                          key: 'emoti_q.mentor_goal',
                          answer_keys: [
                            'emoti_q.tranquilo',
                            'emoti_q.mejorar_relaciones',
                            'emoti_q.autoestima',
                            'emoti_q.claridad',
                            'emoti_q.habilidades_emociones'
                          ]
                        }
                      ])
