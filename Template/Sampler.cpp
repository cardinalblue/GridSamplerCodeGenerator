#include <cstdlib>
#include <string>
#include <sstream>
#include "${{SamplerName}}Sampler.hpp"
#include <Util.hpp>


const std::string gGridName("${{LowerCaseSamplerName}}: ");

${{SamplerName}}Sampler::${{SamplerName}}Sampler(int layoutPolicy,
                       int genPolicy)
: IGridsGenerator(layoutPolicy, genPolicy) {

    mBucket.resize(${{GridCount}});
    // A temporary realGrid list container.
    std::vector<Grid> tmpGrids;
    ${{Content}}
}

${{SamplerName}}Sampler::~${{SamplerName}}Sampler() {
    mBucket.clear();
}

std::vector<Grid> ${{SamplerName}}Sampler::sample(RectF& canvas,
                                          std::vector<Photo>& photos) {
    if (photos.size() < mBucket.size()) {
        return mBucket[photos.size()];
    } else {
        // TODO: We still need valid results.
        return std::vector<Grid>(0);
    }
}
