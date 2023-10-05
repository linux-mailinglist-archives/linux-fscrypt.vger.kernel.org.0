Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD677B9A11
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 Oct 2023 04:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjJECq2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Oct 2023 22:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbjJECq1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Oct 2023 22:46:27 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FA11C0;
        Wed,  4 Oct 2023 19:46:24 -0700 (PDT)
Received: from [10.137.106.151] (unknown [131.107.159.23])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4A2ED20B74C0;
        Wed,  4 Oct 2023 19:46:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4A2ED20B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1696473983;
        bh=Tk/tWsa69Leyj9ipJnNt9y71v/ZHhVK2fPaRDp6yvHQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZQxoETTv2uriamkJ6lcmJ39iqLPRnLv5GPtaWy8Cgj0R2TbpV39ck1IMfXgHmLpSU
         V+Uu7J0ybvJh7tNBgQDYmTIlaWfSFLpTvLyQhdcaxLt7Lc2w56HcJAKUG31fioNpzB
         ZAoqtGDUC5O8nf+oC1KzCGnUrL5/L/89+LLpsR+M=
Message-ID: <a58cc269-1a95-445d-85c9-ecf997b47294@linux.microsoft.com>
Date:   Wed, 4 Oct 2023 19:45:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v11 16/19] ipe: enable support for fs-verity as a
 trust provider
To:     Randy Dunlap <rdunlap@infradead.org>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com,
        paul@paul-moore.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
References: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
 <1696457386-3010-17-git-send-email-wufan@linux.microsoft.com>
 <7cecea3f-aaca-4df5-9595-324137c3627e@infradead.org>
Content-Language: en-US
From:   Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <7cecea3f-aaca-4df5-9595-324137c3627e@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 10/4/2023 4:58 PM, Randy Dunlap wrote:
> 
> 
> On 10/4/23 15:09, Fan Wu wrote:
> 
> | diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
> | index 7afb1ce0cb99..9dd5c4769d79 100644
> | --- a/security/ipe/Kconfig
> | +++ b/security/ipe/Kconfig
> | @@ -30,6 +30,19 @@ config IPE_PROP_DM_VERITY
> |  	  that was mounted with a signed root-hash or the volume's
> |  	  root hash matches the supplied value in the policy.
> |
> | +	  If unsure, answer Y.
> | +
> | +config IPE_PROP_FS_VERITY
> | +	bool "Enable property for fs-verity files"
> | +	depends on FS_VERITY && FS_VERITY_BUILTIN_SIGNATURES
> | +	help
> | +	  This option enables the usage of properties "fsverity_signature"
> | +	  and "fsverity_digest". These properties evaluates to TRUE when
> 
> 	                                          evaluate
> 
> | +	  a file is fsverity enabled and with a signed digest or its
> | +	  diegst matches the supplied value in the policy.
> 
> 	  digest
> 
> | +
> | +	  if unsure, answer Y.
> | +
> |  endmenu
> |
> |  endif
> 
> 

Thanks for catching the typo/error. Not sure why my spell script didn't 
find them. Maybe I should consider using a better tool.

-Fan
