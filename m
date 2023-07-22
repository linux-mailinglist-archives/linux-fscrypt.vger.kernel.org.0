Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5ECD75D99E
	for <lists+linux-fscrypt@lfdr.de>; Sat, 22 Jul 2023 06:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjGVESa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 22 Jul 2023 00:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjGVES3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 22 Jul 2023 00:18:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51CE35B3;
        Fri, 21 Jul 2023 21:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58F3C60959;
        Sat, 22 Jul 2023 04:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61034C433C9;
        Sat, 22 Jul 2023 04:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689999506;
        bh=kag+ohL9tZ6fXmrE3aHIZj7tEdV68M408h4BhDAly3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h7u2inUHslH3y75JydPGrHeMMpLK/Ysq6lbkulrrllYWRhR4N5rA0pJddDfiD7jMn
         OTcmKj96o04DoZwEIZ5EfsFxtG9i67vSHA5N6JhrZIy78YuhYEqCQRDU0xpw/dLful
         CHJfi+mM4R1E07rIo5Hmt9UlobNZ5dsexDhlb0144rHZvVYLTGUx6SimFjmGYY00Xv
         esuVrked/FGbuJuvwVfGom4wLfKYhLu79W6qHGt9axmS8syTxsxqdYDFECDnCE3bY9
         FhoJG/ZlNoZgh3rvWlS0UDyrU6K3C2H+2wtS7UvnYlM0Q7EL2770NdI1ZNXmpnfHQj
         PW3YqGbGJkKTA==
Date:   Fri, 21 Jul 2023 21:18:24 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Bjorn Andersson <andersson@kernel.org>
Cc:     Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, omprsing@qti.qualcomm.com,
        quic_psodagud@quicinc.com, avmenon@quicinc.com,
        abel.vesa@linaro.org, quic_spuppala@quicinc.com
Subject: Re: [PATCH v2 02/10] qcom_scm: scm call for deriving a software
 secret
Message-ID: <20230722041824.GB5660@sol.localdomain>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <20230719170423.220033-3-quic_gaurkash@quicinc.com>
 <bhsyywrocfv256yi5hxticc72ojxelilezpnj67hauqqexokut@j2ivxaaaupdn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bhsyywrocfv256yi5hxticc72ojxelilezpnj67hauqqexokut@j2ivxaaaupdn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jul 21, 2023 at 08:50:56PM -0700, Bjorn Andersson wrote:
> > +/**
> > + * qcom_scm_derive_sw_secret() - Derive SW secret from wrapped key
> > + * @wrapped_key: the wrapped key used for inline encryption
> > + * @wrapped_key_size: size of the wrapped key
> 
> Following my reply on patch 7, how about dropping the "_key" suffix on
> these.
> 
> > + * @sw_secret: the secret to be derived which is exactly the secret size
> 
> Similarly the "sw_" prefix doesn't see to add value, please omit it.

The name 'sw_secret' comes from the block layer support
(https://lore.kernel.org/linux-block/20221216203636.81491-2-ebiggers@kernel.org/).
It is helpful to call it 'sw_secret' instead of 'secret', as there are other
types of secrets involved that are not accessible to software (Linux).

- Eric
