#ifndef CB_ALGORITHMS_LIB_${{UpperCaseSamplerName}}SAMPLER_H
#define CB_ALGORITHMS_LIB_${{UpperCaseSamplerName}}SAMPLER_H

#include <vector>
#include <Photo.hpp>
#include <Grid.hpp>
#include <IGridsGenerator.hpp>

class ${{SamplerName}}Sampler : public IGridsGenerator {
public:
    ${{SamplerName}}Sampler(int layoutPolicy,
               int genPolicy);

    ~${{SamplerName}}Sampler();

    std::vector<Grid> sample(RectF& canvas,
                             std::vector<Photo>& photos);

protected:
    std::vector<std::vector<Grid> > mBucket;

};

#endif
