gunzip /workspace/search_with_machine_learning_course/data/*/*.xml.gz
python /workspace/search_with_machine_learning_course/week3/createContentTrainingData.py --sample_rate 0.5 --min_products 10

shuf /workspace/datasets/categories/output.fasttext > /workspace/datasets/categories/shuffled.fasttext

#get line count
wc -l /workspace/datasets/fasttext/shuffled.fasttext

# train and test
head -n 10000 /workspace/datasets/categories/shuffled.fasttext > /workspace/datasets/categories/train.fasttext
tail -n 10000 /workspace/datasets/categories/shuffled.fasttext > /workspace/datasets/categories/test.fasttext

# Validation set (not in test or train)
sed '50000,55000 ! d' /workspace/datasets/categories/shuffled.fasttext > /workspace/datasets/categories/validate.fasttext

# move to where the data is
cd /workspace/datasets/categories

# Train a model
~/fastText-0.9.2/fasttext supervised -input train.fasttext -output categories -epoch 50 -wordNgrams 2 -lr 2

# Get the metrics
~/fastText-0.9.2/fasttext test products.bin test.fasttext


# Synonyms:
python /workspace/search_with_machine_learning_course/week3/extractTitles.py --sample_rate 1
cd /workspace/datasets/fasttext/
~/fastText-0.9.2/fasttext skipgram -input titles.txt -output synonyms -maxn 5 -minn 3 -dim 25 -epoch 25 -minCount 7 -lr 0.25 -wordNgrams 3