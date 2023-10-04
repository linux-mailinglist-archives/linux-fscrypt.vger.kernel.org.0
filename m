Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D17577B98FA
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 Oct 2023 01:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243808AbjJDX7E (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Oct 2023 19:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjJDX7D (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Oct 2023 19:59:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5549E;
        Wed,  4 Oct 2023 16:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=8bHwpVVd6d69HoBRfKHhsJ6ej2qirXfuILe1zt+xN2c=; b=g6YEbwgZo7Uv+8eOWh8j3/AJJf
        LKvBzoX3cs7SePusd2TeD0N3Lw+fFlq6Zu9N5yIZh+9N72mjPXuJzIOToQa0h0sPUBmuPyfVTNFmU
        x5wQJVAokysYbC9hDVGZjHz0DyxqlYiyWrQy5FtCe3WNbFKUxnTNHhox1VBtR41JYOF4SxrW4dkL/
        RRm4kPV8eRY3OWvtT882d8TMfJwZGC0jU2Xcdh27n7ryu7O/BJ0blDJt5BFiFAEUTCIH65lapTL4R
        LWVDpQbBZUTl8H8J18KOAyKDLPFwk9sV1A4QZ79evhehGQAMgePTK4f0xI8JhCvPZKuFyKznS1Y7o
        qE5H25ow==;
Received: from [50.53.46.231] (helo=[192.168.254.15])
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qoBlI-00182U-0V;
        Wed, 04 Oct 2023 23:58:40 +0000
Message-ID: <7cecea3f-aaca-4df5-9595-324137c3627e@infradead.org>
Date:   Wed, 4 Oct 2023 16:58:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v11 16/19] ipe: enable support for fs-verity as a
 trust provider
Content-Language: en-US
To:     Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net,
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
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <1696457386-3010-17-git-send-email-wufan@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 10/4/23 15:09, Fan Wu wrote:

| diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
| index 7afb1ce0cb99..9dd5c4769d79 100644
| --- a/security/ipe/Kconfig
| +++ b/security/ipe/Kconfig
| @@ -30,6 +30,19 @@ config IPE_PROP_DM_VERITY
|  	  that was mounted with a signed root-hash or the volume's
|  	  root hash matches the supplied value in the policy.
|  
| +	  If unsure, answer Y.
| +
| +config IPE_PROP_FS_VERITY
| +	bool "Enable property for fs-verity files"
| +	depends on FS_VERITY && FS_VERITY_BUILTIN_SIGNATURES
| +	help
| +	  This option enables the usage of properties "fsverity_signature"
| +	  and "fsverity_digest". These properties evaluates to TRUE when

	                                          evaluate

| +	  a file is fsverity enabled and with a signed digest or its
| +	  diegst matches the supplied value in the policy.

	  digest

| +
| +	  if unsure, answer Y.
| +
|  endmenu
|  
|  endif


-- 
~Randy
