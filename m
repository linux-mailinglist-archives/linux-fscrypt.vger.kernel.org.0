Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865A9776FA1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Aug 2023 07:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbjHJFgq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Aug 2023 01:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbjHJFgp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Aug 2023 01:36:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D2F10C3;
        Wed,  9 Aug 2023 22:36:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 209A763A11;
        Thu, 10 Aug 2023 05:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA7DC433C8;
        Thu, 10 Aug 2023 05:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691645804;
        bh=tcSjhntVhHGs4LILxZjnhlkjuBObmtnak8S0wqOrdng=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n+H6NfEg855xY5gp8DtQ7B5dL3rY7g+XYwU0/nEtnsIUlfwPpKioE3NIAq1blAI9F
         YTXFxZ3MbxJ157LL0FcQpT/PpV9mghO5vMZRcu76xRzgcapu6hc1nApVNHysdivVpa
         rJRtKebueZEUxXZXlbpuEy+4DQaYCrHs8KL27l8Pnpc2kpQwwEMeF/IvLtBwGdbKB7
         V0giFR0eFAiCffz4u1LptdHNLFuNO8H22Y0L8jFuZkiv+HAL+zcKAHFgkeBZkklN6y
         TdU3uYYefWJVYEe1jo912z1K+BnN8pVtNjupDDiHKX5djgd39y6A/VxW1zOM9AL/6B
         RT6jWJT9AUwmA==
Date:   Wed, 9 Aug 2023 22:36:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        Om Prakash Singh <omprsing@qti.qualcomm.com>,
        "Prasad Sodagudi (QUIC)" <quic_psodagud@quicinc.com>,
        "Arun Menon (SSG)" <avmenon@quicinc.com>,
        "abel.vesa@linaro.org" <abel.vesa@linaro.org>,
        "Seshu Madhavi Puppala (QUIC)" <quic_spuppala@quicinc.com>
Subject: Re: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and
 ufs
Message-ID: <20230810053642.GD923@sol.localdomain>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <20230720025541.GA2607@sol.localdomain>
 <ca11701e403f48b6839b26c47a1b537f@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca11701e403f48b6839b26c47a1b537f@quicinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 01, 2023 at 05:31:59PM +0000, Gaurav Kashyap (QUIC) wrote:
> 
> According to your cover letter, this feature requires a custom TrustZone image to work on SM8550.  Will that image be made available outside Qualcomm?
> --> Unfortunately, I don't think there is a way to do that. You can still request for one through our customer engineering team like before.

I think it's already been shown that that is not a workable approach.

> Also, can you please make available a git branch somewhere that contains your patchset?  It sounds like this depends on https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=wrapped-keys-v7, but actually a version of it that you've rebased, which I don't have access to.
> Without being able to apply your patchset, I can't properly review it.
> --> As for the fscrypt patches,
>       I have not changed much functionally from the v7 patch, just merge conflicts.
>       I will update this thread once I figure out a git location.
> 

Any update on this?  Most kernel developers just create a GitHub repo if they
don't have kernel.org access.

- Eric
