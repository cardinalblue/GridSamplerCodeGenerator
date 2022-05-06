#ifndef CB_ALGORITHMS_LIB_ADDITIONSVGSAMPLER_H
#define CB_ALGORITHMS_LIB_ADDITIONSVGSAMPLER_H

#include <vector>
#include <Photo.hpp>
#include <Grid.hpp>
#include <IGridsGenerator.hpp>

class AdditionSVGSampler : public IGridsGenerator {
public:
    AdditionSVGSampler(int layoutPolicy,
               int genPolicy);

    ~AdditionSVGSampler();

    std::vector<Grid> sample(RectF& canvas,
                             std::vector<Photo>& photos);

protected:
    std::vector<std::vector<Grid> > mBucket;

};

#endif
