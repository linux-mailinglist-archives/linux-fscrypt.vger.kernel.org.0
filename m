Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5066B2D5F63
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Dec 2020 16:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390966AbgLJPTy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Dec 2020 10:19:54 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:45744 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389991AbgLJPTm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Dec 2020 10:19:42 -0500
Received: by mail-oi1-f196.google.com with SMTP id f132so6054437oib.12;
        Thu, 10 Dec 2020 07:19:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=isKnpZLWDmxxb3Yjeaxd76RZPLoaSrKYVnhT82zCGQk=;
        b=D8dbadE7cID3JgFlb5YELFKUw0DYmFD2vGoHnrDYzje8p5y+NM56bvUjp1hP9QDBxY
         zWor0ONLtl9U+ZmiNJRqziby0eOtofXPHSdqOJOYbj7FWnB2ICzHWWaIV16nhTDzHM1a
         CrpKEbqvYdhOfG30vkWNiy7aYK6yabDT+Vv44s/HfwkCCc2eGyyJ8fi35Sgmp5HKOG7e
         6XDYP2uDcyH8cjwz+cRlVOV4My3npeSfOffDP9bLHz+aM5/5IXDuN8TZVi/3RaZL90lS
         bv7HiJ55mDZf86LoAzj2xDflB2ud1lt+H0dGZ8xSHhBeh9cTYSGqa5eXRuvu9BR5Ztb/
         t1QQ==
X-Gm-Message-State: AOAM531qOVU1Aa+3NiVI6nO9wP7uNjmh+6XLEZI/rvLtLxd1cmH/VV8i
        rvctUcypd0jSGepVboHbSQ==
X-Google-Smtp-Source: ABdhPJzA2iPp0rG4sGDDN0cx8K+xg1jPuuOC+wTD2Jx83mP/UbjeOKKl42g17sulPm6+QYKwvMVlew==
X-Received: by 2002:aca:5204:: with SMTP id g4mr5750242oib.91.1607613541539;
        Thu, 10 Dec 2020 07:19:01 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id z10sm1065948oom.3.2020.12.10.07.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 07:19:00 -0800 (PST)
Received: (nullmailer pid 2523995 invoked by uid 1000);
        Thu, 10 Dec 2020 15:18:59 -0000
Date:   Thu, 10 Dec 2020 09:18:59 -0600
From:   Rob Herring <robh@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Neeraj Soni <neersoni@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-fscrypt@vger.kernel.org,
        Konrad Dybcio <konradybcio@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Asutosh Das <asutoshd@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Satya Tangirala <satyat@google.com>,
        devicetree@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH v3 7/9] dt-bindings: mmc: sdhci-msm: add ICE registers
 and clock
Message-ID: <20201210151859.GA2523965@robh.at.kernel.org>
References: <20201209044238.78659-1-ebiggers@kernel.org>
 <20201209044238.78659-8-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209044238.78659-8-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 08 Dec 2020 20:42:36 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Document the bindings for the registers and clock for the MMC instance
> of the Inline Crypto Engine (ICE) on Snapdragon SoCs.  These bindings
> are needed in order for sdhci-msm to support inline encryption.
> 
> Reviewed-by: Satya Tangirala <satyat@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  Documentation/devicetree/bindings/mmc/sdhci-msm.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
