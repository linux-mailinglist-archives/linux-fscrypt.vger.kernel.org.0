Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54FE78CDFF
	for <lists+linux-fscrypt@lfdr.de>; Tue, 29 Aug 2023 23:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239416AbjH2VGf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 29 Aug 2023 17:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240627AbjH2VGU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 29 Aug 2023 17:06:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB662CC0;
        Tue, 29 Aug 2023 14:06:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A3CD6458B;
        Tue, 29 Aug 2023 21:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3858C433C8;
        Tue, 29 Aug 2023 21:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693343176;
        bh=qiAWSGk1aWDK6sJzEVsHWsdEaVCe8feJwDVoJcyUs/o=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=S4KeBI/69+7Ayd9R9KTLdVmqQiZm7mcXEWorWqEFSro6bf37+t5OA/CZ+amgUVah6
         2+oBiCqAKiVqVIgBpb0FfDk9zWTrpPFk1G5sbHt3WtKbtNcu8n/Q6nyQ/3OKOzyoZf
         DzYaqjt2b4dbU+9/rDJb9Q8cEGtHDKBdik4IwYcvjQMGmy39GWw4giM+OdkKZYRKlY
         oJjQFpXyLVCCAV//iXR/uweysFGffhfwvOqWdGohxxkoo2zW9M9UlX3ACGikSEZK4E
         dMo64UgiYTTzBvSRSaPU/ejklsmJc9fiY6bAiFevD64UGbP08B2uAsDV5szm+eY3Xh
         aDrVyUHw9q52w==
Message-ID: <c96c788e-c218-4d14-92c5-37b1db961b9f@kernel.org>
Date:   Tue, 29 Aug 2023 23:06:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and
 ufs
Content-Language: en-US
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ebiggers@google.com
Cc:     linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, omprsing@qti.qualcomm.com,
        quic_psodagud@quicinc.com, avmenon@quicinc.com,
        abel.vesa@linaro.org, quic_spuppala@quicinc.com
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
From:   Konrad Dybcio <konradybcio@kernel.org>
In-Reply-To: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 19.07.2023 19:04, Gaurav Kashyap wrote:
> These patches add support to Qualcomm ICE (Inline Crypto Enginr) for hardware
> wrapped keys using Qualcomm Hardware Key Manager (HWKM) and are made on top
> of a rebased version  Eric Bigger's set of changes to support wrapped keys in
> fscrypt and block below:
> https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=wrapped-keys-v7
> (The rebased patches are not uploaded here)
Please make sure to also CC maintainers of the related subsystems.

I recommend using the b4 tool [1], which takes care of this and similar
issues.

[1] https://b4.docs.kernel.org/en/latest/index.html

Konrad
