<template>
    <div class="w-full h-full align-middle justify-center text-center @container">
        <div class="@lg:relative @lg:top-16 @lg:border-1 @lg:border-solid @lg:border-gray-200 rounded-lg @lg:p-4 @lg:w-1/3 @lg:m-auto text-center">
            <a-page-header class="m-auto" title="卡 BIN 检测器" subtitle="不保证准确度。" @back="$router.back()" />
            <p class="text-gray-500 mt-2">在下方输入六位数的卡BIN</p>
            <a-verification-code size="large" v-model="value" style="width: 300px" @finish="onFinish" class="m-auto mt-6" />
            <a-empty v-if="!binData.valid"/>
            <template v-else>
                <a-card title="检测结果" class="m-auto text-center mt-6">
                    <a-list>
                        <a-list-item>
                            <a-list-item-meta title="卡类型"></a-list-item-meta>
                            <template #extra>
                                <i :class="getCardTypeIcon(binData.type)"></i> {{ getCardType(binData.type) }}
                            </template>
                        </a-list-item>
                        <a-list-item>
                            <a-list-item-meta title="卡组织"></a-list-item-meta>
                            <template #extra>
                                <i :class="getCardBrandIcon(binData.brand)"></i> {{ getCardBrand(binData.brand) }}
                            </template>
                        </a-list-item>
                        <a-list-item>
                            <a-list-item-meta title="卡等级"></a-list-item-meta>
                            <template #extra>
                                <i :class="getCardLevelIcon(binData.level)"></i> {{ getCardLevel(binData.level) }}
                            </template>
                        </a-list-item>
                        <a-list-item>
                            <a-list-item-meta title="发卡行"></a-list-item-meta>
                            <template #extra>{{ binData.issuer.name }}</template>
                        </a-list-item>
                        <a-list-item>
                            <a-list-item-meta title="国家"></a-list-item-meta>
                            <template #extra>{{ binData.country.name }}</template>
                        </a-list-item>
                    </a-list>
                </a-card>
            </template>
        </div>
    </div>
</template>

<script setup lang="ts">
useHead({ title: '卡 BIN 检测器' })

const value = ref('')
const binData = ref<any>({})
const onFinish = async() => {
    const data = await $fetch('/api/getBin', {
        method: 'POST',
        body: { bin: value.value }
    })
    if (data.statusCode == 200){
        // @ts-ignore
        binData.value = data.data.BIN
    }
    else{
        // @ts-ignore
        Message.error(data.message || '未知错误')
    }
}

const getCardLevel = (level: string) => {
    switch(level){
        case 'STANDARD': return '普卡'
        case 'GOLD': return '金卡'
        case 'PLATINUM': return '白金卡'
        case 'DIAMOND': return '钻石卡'
        case 'PERSONAL': return '私人银行卡（部分银行可能滥发此卡段，不准确）'
        case 'WORLD': return 'MC 世界卡'
        case 'WORLD ELITE': return 'MC 世界之极卡'
        case 'SIGNATURE': return 'VISA 御玺卡'
        case 'INFINITE': return 'VISA 无限卡'
        case 'BUSINESS': return '商务卡'
        case 'CORPORATE': return '公司卡'
        case 'PREMIER': return '高端卡'
        case 'PREMIER WORLD': return '高端世界卡'
        default: return '未知（欢迎补充）'
    }
}

const getCardBrand = (brand: string) => {
    switch(brand){
        case 'VISA': return 'VISA'
        case 'MASTERCARD': return 'MasterCard'
        case 'AMERICAN EXPRESS': return '美国运通'
        case 'DISCOVER': return 'Discover'
        case 'JCB': return 'JCB'
        case 'DINERS CLUB': return 'Diners Club'
        case 'CHINA UNION PAY': return '银联'
        default: return '未知（欢迎补充）'
    }
}

const getCardType = (type: string) => {
    switch(type){
        case 'DEBIT': return '借记卡'
        case 'CREDIT': return '信用卡'
        case 'CHARGE': return '充值卡'
        case 'PREPAID': return '预付卡'
        case 'UNKNOWN': return '未知（API未知）'
        default: return '未知（欢迎补充）'
    }
}

const getCardTypeIcon = (type: string) => {
    const typeIcons: Record<string, string> = {
        'DEBIT': 'fa-solid fa-money-bill-wave',
        'CREDIT': 'fa-solid fa-credit-card',
        'CHARGE': 'fa-solid fa-wallet',
        'PREPAID': 'fa-solid fa-piggy-bank'
    };
    return typeIcons[type] || 'fa-solid fa-question';
}

const getCardBrandIcon = (brand: string) => {
    const brandIcons: Record<string, string> = {
        'VISA': 'fa-brands fa-cc-visa',
        'MASTERCARD': 'fa-brands fa-cc-mastercard',
        'AMERICAN EXPRESS': 'fa-brands fa-cc-amex',
        'DISCOVER': 'fa-brands fa-cc-discover',
        'JCB': 'fa-brands fa-cc-jcb',
        'DINERS CLUB': 'fa-brands fa-cc-diners-club',
        'CHINA UNION PAY': 'fa-solid fa-credit-card'
    };
    return brandIcons[brand] || 'fa-solid fa-question';
}

const getCardLevelIcon = (level: string) => {
    const levelIcons: Record<string, string> = {
        'STANDARD': 'fa-solid fa-circle',
        'GOLD': 'fa-solid fa-crown',
        'PLATINUM': 'fa-solid fa-gem',
        'DIAMOND': 'fa-solid fa-diamond',
        'WORLD': 'fa-solid fa-globe',
        'WORLD ELITE': 'fa-solid fa-globe-americas',
        'SIGNATURE': 'fa-solid fa-pen-fancy',
        'INFINITE': 'fa-solid fa-infinity',
        'BUSINESS': 'fa-solid fa-briefcase',
        'CORPORATE': 'fa-solid fa-building',
        'PREMIER': 'fa-solid fa-star',
        'PREMIER WORLD': 'fa-solid fa-globe-europe'
    };
    return levelIcons[level] || 'fa-solid fa-question';
}
</script>

<style>
@import "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css";
</style>