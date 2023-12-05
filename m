Return-Path: <linux-fscrypt+bounces-49-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E77805B31
	for <lists+linux-fscrypt@lfdr.de>; Tue,  5 Dec 2023 18:34:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D0CF1F2185B
	for <lists+linux-fscrypt@lfdr.de>; Tue,  5 Dec 2023 17:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72BDF68B6E;
	Tue,  5 Dec 2023 17:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lYNsBBqo"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC171A1
	for <linux-fscrypt@vger.kernel.org>; Tue,  5 Dec 2023 09:33:58 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-40c032962c5so43035275e9.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 05 Dec 2023 09:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701797636; x=1702402436; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VJL8PlMbGmUjOCL0RQsFaIVNSGNIFrU43ufyj8haIXI=;
        b=lYNsBBqo9B8Cte2tUfX6FH4vb9yuQyZSjGYwKcQYwWNOVys6iNydTyGWfVXgWN8cKR
         aMH5H35TxF/5jsW5SRqrWZgCttNtGxVl5qiZ8eoEHOkkBJH3tmzI2ctj7dFHNKLfyBQN
         BkNFRWZ1gHD9w4ivw2bOnzYQLdis8SFjWhxnGWGmkjkRbjw91eDq4LK8vmu5pufd2QFd
         V6eMwVkLEI8+OTfj7mXFlkCO/Znh4QxpFxK0VzPAqWwUOrIMV2rHDSZ6G8xvyfBcwYrV
         yjqWNxBomTyev8o1BV+jMInp/nKPY/HdCzg9DhRMAAbG8NidF0SNJXJ+ypOKkfW4Lr2t
         RM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701797636; x=1702402436;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VJL8PlMbGmUjOCL0RQsFaIVNSGNIFrU43ufyj8haIXI=;
        b=nVEnbQ9XBLag6jxSBJguOX0qQnZxdMjQIhKJiMJdF3G+ptV39pbCkcVGH4AvuF5uk7
         kS+CTBvuzQlCvQRXwKJo0r8rwJ71nrRnB/QTPx1JDobcB2OJi/PPaHzzemPbfP8A+hqR
         4fHPI6ftQ/Mai/hMVhSFEeECCPRnwxoCk7N1PYDNA6Ai2ubouZJrydhXjKQsxzK2JkDe
         zxeebRMqqOtC4w3jPguLLJg7If8YREyQy4ngETkPmNeLYQI46yWwOnrYfsNScNqrDVqZ
         RLu9o6eJ4STSwaEe9n8CjwuBhaP17ACwTZBBbAESD3UcfzfW2WUDrBOBoxJzbvKI6AL9
         BMHA==
X-Gm-Message-State: AOJu0Ywhfi/IogEe1/md54IYxw3dgxHuDMEa4KzmP+9+XsUCB1eAkkVt
	++v/kxldhYTbw7pN3H3yG5qllQ==
X-Google-Smtp-Source: AGHT+IHBIsl3mYv3KXrgx9Ctqap8Zyx0kHI99w5JKnXrWg6CnRY/rCgHaZbjAHIbGhg00vREgMtCdQ==
X-Received: by 2002:a05:600c:1d0b:b0:40c:90f:e51f with SMTP id l11-20020a05600c1d0b00b0040c090fe51fmr571638wms.172.1701797636303;
        Tue, 05 Dec 2023 09:33:56 -0800 (PST)
Received: from ?IPV6:2a01:e0a:982:cbb0:a215:77cd:3141:d5d0? ([2a01:e0a:982:cbb0:a215:77cd:3141:d5d0])
        by smtp.gmail.com with ESMTPSA id a13-20020a05600c348d00b0040b5377cf03sm23144654wmq.1.2023.12.05.09.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 09:33:55 -0800 (PST)
Message-ID: <9ba9be67-93a3-4c08-8410-adc9de3e45b4@linaro.org>
Date: Tue, 5 Dec 2023 18:33:54 +0100
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: neil.armstrong@linaro.org
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v3 00/12] Hardware wrapped key support for qcom ice and
 ufs
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>, linux-scsi@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, ebiggers@google.com,
 srinivas.kandagatla@linaro.org
Cc: linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, omprsing@qti.qualcomm.com,
 quic_psodagud@quicinc.com, abel.vesa@linaro.org, quic_spuppala@quicinc.com,
 kernel@quicinc.com
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
Content-Language: en-US, fr
Autocrypt: addr=neil.armstrong@linaro.org; keydata=
 xsBNBE1ZBs8BCAD78xVLsXPwV/2qQx2FaO/7mhWL0Qodw8UcQJnkrWmgTFRobtTWxuRx8WWP
 GTjuhvbleoQ5Cxjr+v+1ARGCH46MxFP5DwauzPekwJUD5QKZlaw/bURTLmS2id5wWi3lqVH4
 BVF2WzvGyyeV1o4RTCYDnZ9VLLylJ9bneEaIs/7cjCEbipGGFlfIML3sfqnIvMAxIMZrvcl9
 qPV2k+KQ7q+aXavU5W+yLNn7QtXUB530Zlk/d2ETgzQ5FLYYnUDAaRl+8JUTjc0CNOTpCeik
 80TZcE6f8M76Xa6yU8VcNko94Ck7iB4vj70q76P/J7kt98hklrr85/3NU3oti3nrIHmHABEB
 AAHNKk5laWwgQXJtc3Ryb25nIDxuZWlsLmFybXN0cm9uZ0BsaW5hcm8ub3JnPsLAkQQTAQoA
 OwIbIwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgBYhBInsPQWERiF0UPIoSBaat7Gkz/iuBQJk
 Q5wSAhkBAAoJEBaat7Gkz/iuyhMIANiD94qDtUTJRfEW6GwXmtKWwl/mvqQtaTtZID2dos04
 YqBbshiJbejgVJjy+HODcNUIKBB3PSLaln4ltdsV73SBcwUNdzebfKspAQunCM22Mn6FBIxQ
 GizsMLcP/0FX4en9NaKGfK6ZdKK6kN1GR9YffMJd2P08EO8mHowmSRe/ExAODhAs9W7XXExw
 UNCY4pVJyRPpEhv373vvff60bHxc1k/FF9WaPscMt7hlkbFLUs85kHtQAmr8pV5Hy9ezsSRa
 GzJmiVclkPc2BY592IGBXRDQ38urXeM4nfhhvqA50b/nAEXc6FzqgXqDkEIwR66/Gbp0t3+r
 yQzpKRyQif3OwE0ETVkGzwEIALyKDN/OGURaHBVzwjgYq+ZtifvekdrSNl8TIDH8g1xicBYp
 QTbPn6bbSZbdvfeQPNCcD4/EhXZuhQXMcoJsQQQnO4vwVULmPGgtGf8PVc7dxKOeta+qUh6+
 SRh3vIcAUFHDT3f/Zdspz+e2E0hPV2hiSvICLk11qO6cyJE13zeNFoeY3ggrKY+IzbFomIZY
 4yG6xI99NIPEVE9lNBXBKIlewIyVlkOaYvJWSV+p5gdJXOvScNN1epm5YHmf9aE2ZjnqZGoM
 Mtsyw18YoX9BqMFInxqYQQ3j/HpVgTSvmo5ea5qQDDUaCsaTf8UeDcwYOtgI8iL4oHcsGtUX
 oUk33HEAEQEAAcLAXwQYAQIACQUCTVkGzwIbDAAKCRAWmrexpM/4rrXiB/sGbkQ6itMrAIfn
 M7IbRuiSZS1unlySUVYu3SD6YBYnNi3G5EpbwfBNuT3H8//rVvtOFK4OD8cRYkxXRQmTvqa3
 3eDIHu/zr1HMKErm+2SD6PO9umRef8V82o2oaCLvf4WeIssFjwB0b6a12opuRP7yo3E3gTCS
 KmbUuLv1CtxKQF+fUV1cVaTPMyT25Od+RC1K+iOR0F54oUJvJeq7fUzbn/KdlhA8XPGzwGRy
 4zcsPWvwnXgfe5tk680fEKZVwOZKIEuJC3v+/yZpQzDvGYJvbyix0lHnrCzq43WefRHI5XTT
 QbM0WUIBIcGmq38+OgUsMYu4NzLu7uZFAcmp6h8g
Organization: Linaro Developer Services
In-Reply-To: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Gaurav,

On 22/11/2023 06:38, Gaurav Kashyap wrote:
> These are the third iteration of patches that add support to Qualcomm ICE (Inline Crypto Engine) for hardware wrapped keys using Qualcomm Hardware Key Manager (HWKM)
> 
> They patches do the following:
> - Address comments from v2 (Found here: https://lore.kernel.org/all/20230719170423.220033-1-quic_gaurkash@quicinc.com/)
> - Rebased and tested on top of Eric's latest patchset: https://lore.kernel.org/all/20231104211259.17448-1-ebiggers@kernel.org/
> - Rebased and tested on top of SM8650 patches from Linaro: https://lore.kernel.org/all/?q=sm8650
> 
> Information about patches copied over from v2:
> 
> "
> Explanation and use of hardware-wrapped-keys can be found here:
> Documentation/block/inline-encryption.rst
> 
> This patch is organized as follows:
> 
> Patch 1 - Prepares ICE and storage layers (UFS and EMMC) to pass around wrapped keys.
> Patch 2 - Adds a new SCM api to support deriving software secret when wrapped keys are used
> Patch 3-4 - Adds support for wrapped keys in the ICE driver. This includes adding HWKM support
> Patch 5-6 - Adds support for wrapped keys in UFS
> Patch 7-10 - Supports generate, prepare and import functionality in ICE and UFS
> 
> NOTE: MMC will have similar changes to UFS and will be uploaded in a different patchset
>        Patch 3, 4, 8, 10 will have MMC equivalents.
> "
> 
> Testing:
> Test platform: SM8650 MTP
> 
> The changes were tested by mounting initramfs and running the fscryptctl
> tool (Ref: https://github.com/ebiggers/fscryptctl/tree/wip-wrapped-keys) to
> generate and prepare keys, as well as to set policies on folders, which
> consequently invokes disk encryption flows through UFS.
> 
> Tested both standard and wrapped keys (Removing qcom,ice-use-hwkm from dtsi will support using standard keys)
> 
> Steps to test:
> 
> The following configs were enabled:
> CONFIG_BLK_INLINE_ENCRYPTION=y
> CONFIG_QCOM_INLINE_CRYPTO_ENGINE=m
> CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y
> CONFIG_SCSI_UFS_CRYPTO=y
> 
> Flash boot image, boot to shell and run the following commands
> 
> Creating and preparing keys
> - mkfs.ext4 -F -O encrypt,stable_inodes /dev/disk/by-partlabel/userdata
> - mount /dev/disk/by-partlabel/userdata -o inlinecrypt /mnt
> - ./fscryptctl generate_hw_wrapped_key /dev/disk/by-partlabel/userdata > /mnt/key.longterm
> Note: import_hw_wrapped_key currently has a big which just got fixed, so it will be functional in the next SM8650 release
> (It might already be available by the time the boards are available to public)
> - ./fscryptctl prepare_hw_wrapped_key /dev/disk/by-partlabel/userdata < /mnt/key.longterm > /tmp/key.ephemeral
> - ./fscryptctl add_key --hw-wrapped-key < /tmp/key.ephemeral /mnt
> 
> Create a folder and associate created keys with the folder
> - rm -rf /mnt/dir
> - mkdir /mnt/dir
> - ./fscryptctl set_policy --hw-wrapped-key --iv-ino-lblk-64 "$keyid" /mnt/dir
> - dmesg > /mnt/dir/test.txt
> - sync
> 
> - Reboot
> - mount /dev/disk/by-partlabel/userdata -o inlinecrypt /mnt
> - ls /mnt/dir (You should see an encrypted file)
> - ./fscryptctl prepare_hw_wrapped_key /dev/disk/by-partlabel/userdata < /mnt/key.longterm > /tmp/key.ephemeral
> - ./fscryptctl add_key --hw-wrapped-key < /tmp/key.ephemeral /mnt
> - cat /mnt/dir/test.txt

I successfully tested with those instructions on the SM8650 QRD,

Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD

however I got some build errors on sdhci-msm:

drivers/mmc/host/sdhci-msm.c:1862:19: error: ‘blk_crypto_key_type’ defined as wrong kind of tag
  1862 |      const struct blk_crypto_key_type *bkey,
       |                   ^~~~~~~~~~~~~~~~~~~
drivers/mmc/host/sdhci-msm.c:1862:19: warning: ‘struct blk_crypto_key_type’ declared inside parameter list will not be visible outside of thi
s definition or declaration
drivers/mmc/host/sdhci-msm.c: In function ‘sdhci_msm_program_key’:
drivers/mmc/host/sdhci-msm.c:1882:24: error: passing argument 4 of ‘qcom_ice_program_key’ from incompatible pointer type [-Werror=incompatibl
e-pointer-types]
  1882 |          ice_key_size, bkey,
       |                        ^~~~
       |                        |
       |                        const struct blk_crypto_key_type *
In file included from drivers/mmc/host/sdhci-msm.c:21:
include/soc/qcom/ice.h:35:34: note: expected ‘const struct blk_crypto_key *’ but argument is of type ‘const struct blk_crypto_key_type *’
    35 |     const struct blk_crypto_key *bkey,
       |     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
drivers/mmc/host/sdhci-msm.c: At top level:
drivers/mmc/host/sdhci-msm.c:1993:17: error: initialization of ‘int (*)(struct cqhci_host *, const struct blk_crypto_key *, const union cqhci
_crypto_cfg_entry *, int)’ from incompatible pointer type ‘int (*)(struct cqhci_host *, const struct blk_crypto_key_type *, const union cqhci_crypto_cfg_entry *, int)’ [-Werro
r=incompatible-pointer-types]
  1993 |  .program_key = sdhci_msm_program_key,
       |                 ^~~~~~~~~~~~~~~~~~~~~
drivers/mmc/host/sdhci-msm.c:1993:17: note: (near initialization for ‘sdhci_msm_cqhci_ops.program_key’)

Thanks,
Neil


> 
> Gaurav Kashyap (12):
>    ice, ufs, mmc: use blk_crypto_key for program_key
>    qcom_scm: scm call for deriving a software secret
>    soc: qcom: ice: add hwkm support in ice
>    soc: qcom: ice: support for hardware wrapped keys
>    ufs: core: support wrapped keys in ufs core
>    ufs: host: wrapped keys support in ufs qcom
>    qcom_scm: scm call for create, prepare and import keys
>    ufs: core: add support for generate, import and prepare keys
>    soc: qcom: support for generate, import and prepare key
>    ufs: host: support for generate, import and prepare key
>    arm64: dts: qcom: sm8650: add hwkm support to ufs ice
>    dt-bindings: crypto: ice: document the hwkm property
> 
>   .../crypto/qcom,inline-crypto-engine.yaml     |   7 +
>   arch/arm64/boot/dts/qcom/sm8650.dtsi          |   3 +-
>   drivers/firmware/qcom/qcom_scm.c              | 276 +++++++++++++++
>   drivers/firmware/qcom/qcom_scm.h              |   4 +
>   drivers/mmc/host/cqhci-crypto.c               |   7 +-
>   drivers/mmc/host/cqhci.h                      |   2 +
>   drivers/mmc/host/sdhci-msm.c                  |   6 +-
>   drivers/soc/qcom/ice.c                        | 321 +++++++++++++++++-
>   drivers/ufs/core/ufshcd-crypto.c              |  87 ++++-
>   drivers/ufs/host/ufs-qcom.c                   |  61 +++-
>   include/linux/firmware/qcom/qcom_scm.h        |   7 +
>   include/soc/qcom/ice.h                        |  18 +-
>   include/ufs/ufshcd.h                          |  22 ++
>   13 files changed, 784 insertions(+), 37 deletions(-)
> 


