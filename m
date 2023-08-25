Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEDB78901E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Aug 2023 23:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbjHYVIF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 25 Aug 2023 17:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjHYVHc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 25 Aug 2023 17:07:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8810E210D;
        Fri, 25 Aug 2023 14:07:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C8A2623E9;
        Fri, 25 Aug 2023 21:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFC4C433C8;
        Fri, 25 Aug 2023 21:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692997649;
        bh=3LZslYY/Z/fNex0qpgIIxBGEpf6J7Qp2wNTLVeCxNak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LR9LYHTCSNbzSLc+a2zNZ2I+W25v/mVPTtA0dzLRVhwjv9G0VM6C/01wxbPexNJtO
         IN/lLLs1iPoI+nWUt3VCKz1XqUmuLxiAnZjft463YjEooqf2k74YRuhYY2sgojQpww
         2w6ScwoHoYzScThIWRmnw+vI3kWLkM5Kn4Gr3VHZEEhTDd0X0IHsQdeL4SY870EbV1
         DkkSIsiiqW2O7RsRITyHVZmniYFOgVbiQ4NOQEFj7zNv0s596W/h8p9WYVIpNkRuyD
         Aqk/94KqUdul3h4G3phhhwwYh3HQYqt1WnZlAZhqehRfSHC2yVWQ00I693urTikF50
         80QLqKOqr3tEg==
Date:   Fri, 25 Aug 2023 14:07:27 -0700
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
Message-ID: <20230825210727.GA1366@sol.localdomain>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <f4b5512b-9922-1511-fc22-f14d25e2426a@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4b5512b-9922-1511-fc22-f14d25e2426a@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Srinivas,

On Fri, Aug 25, 2023 at 11:19:41AM +0100, Srinivas Kandagatla wrote:
> 
> On 19/07/2023 18:04, Gaurav Kashyap wrote:
> > These patches add support to Qualcomm ICE (Inline Crypto Enginr) for hardware
> > wrapped keys using Qualcomm Hardware Key Manager (HWKM) and are made on top
> > of a rebased version  Eric Bigger's set of changes to support wrapped keys in
> > fscrypt and block below:
> > https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=wrapped-keys-v7
> > (The rebased patches are not uploaded here)
> > 
> > Ref v1 here:
> > https://lore.kernel.org/linux-scsi/20211206225725.77512-1-quic_gaurkash@quicinc.com/
> > 
> > Explanation and use of hardware-wrapped-keys can be found here:
> > Documentation/block/inline-encryption.rst
> > 
> > This patch is organized as follows:
> > 
> > Patch 1 - Prepares ICE and storage layers (UFS and EMMC) to pass around wrapped keys.
> > Patch 2 - Adds a new SCM api to support deriving software secret when wrapped keys are used
> > Patch 3-4 - Adds support for wrapped keys in the ICE driver. This includes adding HWKM support
> > Patch 5-6 - Adds support for wrapped keys in UFS
> > Patch 7-10 - Supports generate, prepare and import functionality in ICE and UFS
> > 
> > NOTE: MMC will have similar changes to UFS and will be uploaded in a different patchset
> >        Patch 3, 4, 8, 10 will have MMC equivalents.
> > 
> > Testing:
> > Test platform: SM8550 MTP
> > Engineering trustzone image is required to test this feature only
> > for SM8550. For SM8650 onwards, all trustzone changes to support this
> > will be part of the released images.
> 
> AFAIU, Prior to these proposed changes in scm, HWKM was done with help of
> TA(Trusted Application) for generate, import, unwrap ... functionality.
> 
> 1. What is the reason for moving this from TA to new smc calls?
> 
> Is this because of missing smckinvoke support in upstream?
> 
> How scalable is this approach? Are we going to add new sec sys calls to
> every interface to TA?
> 
> 2. How are the older SoCs going to deal with this, given that you are
> changing drivers that are common across these?
> 
> Have you tested these patches on any older platforms?
> 
> What happens if someone want to add support to wrapped keys to this
> platforms in upstream, How is that going to be handled?
> 
> As I understand with this, we will endup with two possible solutions over
> time in upstream.

It's true that Qualcomm based Android devices already use HW-wrapped keys on
SoCs earlier than SM8650.  The problem is that the key generation, import, and
conversion were added to Android's KeyMint HAL, as a quick way to get the
feature out the door when it was needed (so to speak).  Unfortunately this
coupled this feature unnecessarily to the Android KeyMint and the corresponding
(closed source) userspace HAL provided by Qualcomm, which it's not actually
related to.  I'd guess that Qualcomm's closed source userspace HAL makes SMC
calls into Qualcomm's KeyMint TA, but I have no insight into those details.

The new SMC calls eliminate the dependency on the Android-specific KeyMint.
They're also being documented by Qualcomm.  So, as this patchset does, they can
be used by Linux in the implementation of new ioctls which provide a vendor
independent interface to HW-wrapped key generation, import, and conversion.

I think the new approach is the only one that is viable outside the Android
context.  As such, I don't think anyone has any plan to upstream support for
HW-wrapped keys for older Qualcomm SoCs that lack the new interface.

- Eric
