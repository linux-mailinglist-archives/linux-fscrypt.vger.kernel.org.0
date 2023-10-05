Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D6F7B99E5
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 Oct 2023 04:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbjJEC1R (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Oct 2023 22:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbjJEC1Q (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Oct 2023 22:27:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCA7BF;
        Wed,  4 Oct 2023 19:27:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3366AC433C7;
        Thu,  5 Oct 2023 02:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696472832;
        bh=Dc7ed0EpqwHKkV+keuyjFNWgolgsWB/My9A+mXFzLVk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ielImPInTS8NqY7+g3fPoGycU7A+M62lI7bXjJFPd5Juc7UwVPS0KCS1hJyHORAG/
         ZIC9LbRX7VFpbygRKJ2nubq2i8IgOqlctlcSuckd8fnqwbr3JkLQQXaKkzavQn/SfV
         im1J8A6ugi5p+Lc58jcl6+mJcPutLhpJzqMl5LWhgAbkvyqsG7AysOAmrzYeDq0kio
         p/LBsjBRnjJJHpkIySOI6RU25krmm+qvqeVU0ZTCHXhCo0X5vTlS1xf/E/0Sx+tAci
         Zlr9Q/FUViD0+dTQ0sP5LE8K247pGaWhe5C9XlZsn1wAkNcXjeKd+hqSD2tHFgcDJD
         btFp5u9R1ENkg==
Date:   Wed, 4 Oct 2023 22:27:07 -0400
From:   Eric Biggers <ebiggers@kernel.org>
To:     Fan Wu <wufan@linux.microsoft.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, axboe@kernel.dk, agk@redhat.com,
        snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com,
        linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v11 15/19] fsverity: consume builtin signature via
 LSM hook
Message-ID: <20231005022707.GA1688@quark.localdomain>
References: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
 <1696457386-3010-16-git-send-email-wufan@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1696457386-3010-16-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 04, 2023 at 03:09:42PM -0700, Fan Wu wrote:
> +#ifdef CONFIG_FS_VERITY_BUILTIN_SIGNATURES
> +static int fsverity_inode_setsecurity(struct inode *inode,
> +				      struct fsverity_descriptor *desc)
> +{
> +	return security_inode_setsecurity(inode, FS_VERITY_INODE_SEC_NAME,
> +					  desc->signature,
> +					  le32_to_cpu(desc->sig_size), 0);
> +}

Why isn't the type of the second argument 'const struct fsverity_descriptor *'?

- Eric
