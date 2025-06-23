Emoti.create!([
                {
                  name: "Emoti",
                  title: "Equilibrio Emocional",
                  quote: "Tus emociones merecen ser comprendidas",
                  prompt: "Prompt for Flowa",
                  key: "mamari",
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