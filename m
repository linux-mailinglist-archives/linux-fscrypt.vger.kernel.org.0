Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFDF78CBE1
	for <lists+linux-fscrypt@lfdr.de>; Tue, 29 Aug 2023 20:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjH2SMx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 29 Aug 2023 14:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjH2SM2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 29 Aug 2023 14:12:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EC6109;
        Tue, 29 Aug 2023 11:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F97263C45;
        Tue, 29 Aug 2023 18:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEFDC433C8;
        Tue, 29 Aug 2023 18:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693332744;
        bh=nx79xqGNmXPPNjSKyMSft2vmUfy9hb3j6upsNNfY24I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cgjd0KgEZoIF025z4si4TMZaEkGza9i/CeRoUkoi3zdlFRzCvCWGg0k9uQfK7isFp
         hpGhKfWdIUnYL6OlNBWYQoetRca39I5M2IW0pbJ2HZOxcOOyRwieGF+eHjEu2a/X5Q
         QBNnhE/70eLmI0Px/oxm/XLRVuweMZiSr75u3RNG4x+H+zclx5Jv95CFiMyMgnm1Cd
         2tTBWr4mKGbHkFmikZogWkQKpkyfKUgvBK6tmXl5/X0mi+okSkT+XJGrsCnvlYHkTr
         adHjjFfjNdtIodyLJ/d+F21J/9WleoR1Y18K24VicjYHhEFCy6SHSc9Gg43/56faWC
         bV16h2h5NEe5Q==
Date:   Tue, 29 Aug 2023 18:12:23 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, omprsing@qti.qualcomm.com,
        quic_psodagud@quicinc.com, avmenon@quicinc.com,
        abel.vesa@linaro.org, quic_spuppala@quicinc.com
Subject: Re: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and
 ufs
Message-ID: <20230829181223.GA2066264@google.com>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <f4b5512b-9922-1511-fc22-f14d25e2426a@linaro.org>
 <20230825210727.GA1366@sol.localdomain>
 <f63ce281-1434-f86f-3f4e-e1958a684bbd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f63ce281-1434-f86f-3f4e-e1958a684bbd@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Srinivas,

On Tue, Aug 29, 2023 at 06:11:55PM +0100, Srinivas Kandagatla wrote:
> > It's true that Qualcomm based Android devices already use HW-wrapped keys on
> > SoCs earlier than SM8650.  The problem is that the key generation, import, and
> > conversion were added to Android's KeyMint HAL, as a quick way to get the
> > feature out the door when it was needed (so to speak).  Unfortunately this
> 
> There is an attempt in 2021 todo exactly same thing I guess,
> 
> https://patchwork.kernel.org/project/linux-fscrypt/cover/20211206225725.77512-1-quic_gaurkash@quicinc.com/
> 
> If this was the right thing to do they why is the TZ firmware on SoCs after
> 2021 not having support for this ?

That's on Qualcomm.  But my understanding is that it's just taking them several
years to get the TZ changes out due to their branching schedule.  Garauv
submitted the TZ changes in 2021, but apparently SM8550 had already branched at
that point, so SM8650 is the first one that will have it.

Just because it takes Qualcomm a while to get the firmware support for this
feature deployed doesn't mean that it's the wrong approach.

> 
> > coupled this feature unnecessarily to the Android KeyMint and the corresponding
> > (closed source) userspace HAL provided by Qualcomm, which it's not actually
> 
> So how does Andriod kernel upgrades work after applying this patchset on
> platforms like SM8550 or SM8450 or SM8250..or any old platforms.

The same way they did before.  Older devices won't use this new code.

BTW, this is irrelevant for upstream.

> 
> > related to.  I'd guess that Qualcomm's closed source userspace HAL makes SMC
> > calls into Qualcomm's KeyMint TA, but I have no insight into those details.
> > 
> If we have an smcinvoke tee driver we can talk to to this TA.
> 
> > The new SMC calls eliminate the dependency on the Android-specific KeyMint.
> 
> I can see that.
> 
> Am not against adding this new interface, but is this new interface leaving
> a gap for older platforms?
> 
> 
> Is there any other technical reason for moving out from TA based to a smc
> calls?
> 
> And are we doing a quick solution here to fix something

I have very little insight into Qualcomm's old interface, which is tied to the
Android-specific KeyMint and is not known to be usable outside the Android
context or without the closed source userspace HAL from Qualcomm.

I understand that Linux kernel features that are only usable with closed source
userspace libraries are heavily frowned on.  As are features that are tied to
Android and cannot be used on other Linux distros.

If Qualcomm can document the old interface and show that it's usable directly by
the Linux kernel, then we could consider it.  But without that, the new
interface is our only option.

> > They're also being documented by Qualcomm.  So, as this patchset does, they can
> > be used by Linux in the implementation of new ioctls which provide a vendor
> > independent interface to HW-wrapped key generation, import, and conversion.
> > 
> > I think the new approach is the only one that is viable outside the Android
> > context.  As such, I don't think anyone has any plan to upstream support for
> > HW-wrapped keys for older Qualcomm SoCs that lack the new interface.
> 
> AFAIU, There are other downstream Qualcomm LE platforms that use wrapped key
> support with the older interface.
> What happens to them whey then upgrade the kernel?
> 
> Does TA interface still continue to work with the changes that went into
> common drivers (ufs/sd)?

This is a strange line of questioning for upstream review, as this feature does
not exist upstream.  This is the first time it will be supported by upstream
Linux, ever.  Adding support for this feature does not break anything.

Downstream users who implemented a less well designed version of this feature
can continue to use their existing code.

BTW, I am the person who has gotten stuck maintaining the framework for
HW-wrapped key support in the Android Common Kernels...  So if you're trying to
make things "easier" for me, please don't.  I want to have a properly designed
version of the feature upstream, and then I'll change Android to use that
whenever possible.  That's the only real long-term solution.

- Eric
