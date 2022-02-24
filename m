Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418FF4C20A7
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Feb 2022 01:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiBXAdC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 23 Feb 2022 19:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiBXAcx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 23 Feb 2022 19:32:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD6C83002;
        Wed, 23 Feb 2022 16:32:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1732B82285;
        Thu, 24 Feb 2022 00:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510E8C340E7;
        Thu, 24 Feb 2022 00:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645662741;
        bh=3xhiKUuBO/ryIwyB50Q0hQEcWFfrZ0Emh0O02qSTEMU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i5wkIRMOyyVvPD3+fM5IBNwt4clMFh0hZf35VQl6Iiz8a4IwBBUhXOPJK7fHuff4a
         k7ueAeRuV9vyD4M0rwnp2MIIjslqqcMBg1cTUXUo3CT4+iC0by2I/3RvZGxcwN0p4Z
         H6tQPRNssU9kBpy23l0zk0tboR/EkNEIUtGdwZLCY2BiozFiIFXerYnIv6kxa9XMzI
         NkICB4tQpRACKKbG/evS8MAR+uet6jbqGAUaEBxhoQG8b/8SmZ0zT5FMTeN+qiiUgY
         7siTbLF4/dGfG+3Y5koaYXDEknZXYy1Kcsa1/aloim3dcbRUehEB6VUX6yA3r37Evl
         jLKHbB4Luz7lA==
Date:   Wed, 23 Feb 2022 16:32:19 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/8] ima: define a new template field 'd-type' and a
 new template 'ima-ngv2'
Message-ID: <YhbSE/k4mElcehDN@sol.localdomain>
References: <20220211214310.119257-1-zohar@linux.ibm.com>
 <20220211214310.119257-5-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211214310.119257-5-zohar@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Feb 11, 2022 at 04:43:06PM -0500, Mimi Zohar wrote:
> In preparation to differentiate between regular IMA file hashes and
> fs-verity's file digests, define a new template field named 'd-type'.
> Define a new template named 'ima-ngv2', which includes the new 'd-type'
> field.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>  security/integrity/ima/ima_template.c     |  3 +++
>  security/integrity/ima/ima_template_lib.c | 13 +++++++++++++
>  security/integrity/ima/ima_template_lib.h |  2 ++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
> index db1ad6d7a57f..b321342e5bee 100644
> --- a/security/integrity/ima/ima_template.c
> +++ b/security/integrity/ima/ima_template.c
> @@ -19,6 +19,7 @@ enum header_fields { HDR_PCR, HDR_DIGEST, HDR_TEMPLATE_NAME,
>  static struct ima_template_desc builtin_templates[] = {
>  	{.name = IMA_TEMPLATE_IMA_NAME, .fmt = IMA_TEMPLATE_IMA_FMT},
>  	{.name = "ima-ng", .fmt = "d-ng|n-ng"},
> +	{.name = "ima-ngv2", .fmt = "d-ng|n-ng|d-type"},
>  	{.name = "ima-sig", .fmt = "d-ng|n-ng|sig"},
>  	{.name = "ima-buf", .fmt = "d-ng|n-ng|buf"},
>  	{.name = "ima-modsig", .fmt = "d-ng|n-ng|sig|d-modsig|modsig"},
> @@ -40,6 +41,8 @@ static const struct ima_template_field supported_fields[] = {
>  	 .field_show = ima_show_template_digest_ng},
>  	{.field_id = "n-ng", .field_init = ima_eventname_ng_init,
>  	 .field_show = ima_show_template_string},
> +	{.field_id = "d-type", .field_init = ima_eventdigest_type_init,
> +	 .field_show = ima_show_template_string},
>  	{.field_id = "sig", .field_init = ima_eventsig_init,
>  	 .field_show = ima_show_template_sig},
>  	{.field_id = "buf", .field_init = ima_eventbuf_init,

I notice that the "d-ng" field already contains both the hash algorithm and the
hash itself, in the form <algorithm>:<hash>.  Wouldn't it make more sense to
define a "d-ngv2" field that contains <type>:<algorithm>:<hash>?  After all,
both the type and algorithm are required to interpret the hash.

Or in other words, what about the hash type is different from the hash algorithm
that would result in them needing different handling here?

- Eric
