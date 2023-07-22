Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C404E75DDC5
	for <lists+linux-fscrypt@lfdr.de>; Sat, 22 Jul 2023 19:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjGVR2M (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 22 Jul 2023 13:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjGVR2L (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 22 Jul 2023 13:28:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9381FE1;
        Sat, 22 Jul 2023 10:28:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5E5860B96;
        Sat, 22 Jul 2023 17:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683E6C433C7;
        Sat, 22 Jul 2023 17:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690046888;
        bh=0Qnt2TXZV1Lik9QA9bZlX/qUC3GMD7Pv+tioPCG8a0g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Obf+FpS101ez8jeRWT/1koPBlYqqAWfhNfmVMN+fOXk4ucOf1JFMJdT9HoPcTxYAc
         ZaJ42AJt2a03j1Ua34zF3wZj5GrniKQrOBrl1BK4Jz8MQnPSMisDkGT+DWQLJnM1e1
         Z4dGZKUPxGZDJV//whh3zmjCgpUOaiElEhs32YnLzOyDQCvgjQyFUIuYzMVyW0FaND
         JMHMBY9A33DPv/UkPmtEq9M1ZUl7oNRb0cLNcNde5jJ4Dkvmhp4GUEBBVo+qWYJw3Y
         hvyGiBsANctm/EybUvlZi67KPqfY70mkTT4BzpmvxspnG/Q7v6/mbcaeGmwU+jbRJY
         W+9gJRxApk3+g==
Date:   Sat, 22 Jul 2023 10:31:26 -0700
From:   Bjorn Andersson <andersson@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, omprsing@qti.qualcomm.com,
        quic_psodagud@quicinc.com, avmenon@quicinc.com,
        abel.vesa@linaro.org, quic_spuppala@quicinc.com
Subject: Re: [PATCH v2 02/10] qcom_scm: scm call for deriving a software
 secret
Message-ID: <baycj4irqjarqtivhalcjwthhddrxua6halzku7i7z3t5m736y@reeqynrksprk>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <20230719170423.220033-3-quic_gaurkash@quicinc.com>
 <bhsyywrocfv256yi5hxticc72ojxelilezpnj67hauqqexokut@j2ivxaaaupdn>
 <20230722041824.GB5660@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230722041824.GB5660@sol.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jul 21, 2023 at 09:18:24PM -0700, Eric Biggers wrote:
> On Fri, Jul 21, 2023 at 08:50:56PM -0700, Bjorn Andersson wrote:
> > > +/**
> > > + * qcom_scm_derive_sw_secret() - Derive SW secret from wrapped key
> > > + * @wrapped_key: the wrapped key used for inline encryption
> > > + * @wrapped_key_size: size of the wrapped key
> > 
> > Following my reply on patch 7, how about dropping the "_key" suffix on
> > these.
> > 
> > > + * @sw_secret: the secret to be derived which is exactly the secret size
> > 
> > Similarly the "sw_" prefix doesn't see to add value, please omit it.
> 
> The name 'sw_secret' comes from the block layer support
> (https://lore.kernel.org/linux-block/20221216203636.81491-2-ebiggers@kernel.org/).
> It is helpful to call it 'sw_secret' instead of 'secret', as there are other
> types of secrets involved that are not accessible to software (Linux).
> 

I'm happy with that motivation.

My OCD would like for the length of that to be sw_secret_size (or
perhaps _len instead...), and not "secret_size", then.

Thanks Eric,
Bjorn
