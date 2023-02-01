Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4E7686F27
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Feb 2023 20:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjBATrI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Feb 2023 14:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjBATrA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Feb 2023 14:47:00 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0610A83253;
        Wed,  1 Feb 2023 11:46:47 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 5F2CE20B7102; Wed,  1 Feb 2023 11:46:47 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5F2CE20B7102
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675280807;
        bh=8MDyb8NfMEMA+gvGsYIH3Hk92qnGUNCXXiiUGYDGeY0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aGiTEE1l0zxKt35hRAw5O5rUjHIWcAoDjTu0gK/pqVOhoxy2wEnsm8ZNcF03j15OU
         toc+XIsocCQ+PUZLhpiUjHGzrPbYhknyZg79wHeR50uEX2RjoQI/xWZzNaX8eA9EKw
         t8/KxyA0u4mFqi9fvZeO3cXFFwKkFGDUqHnC4vOk=
Date:   Wed, 1 Feb 2023 11:46:47 -0800
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 05/16] ipe: add userspace interface
Message-ID: <20230201194647.GA11892@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
 <255c119de8f8665b88c411d981762fddc0fe7eaa.camel@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <255c119de8f8665b88c411d981762fddc0fe7eaa.camel@huaweicloud.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jan 31, 2023 at 11:49:44AM +0100, Roberto Sassu wrote:
> On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > +
> > +/**
> > + * new_policy - Write handler for the securityfs node, "ipe/new_policy".
> > + * @f: Supplies a file structure representing the securityfs node.
> > + * @data: Suppleis a buffer passed to the write syscall.
> 
> Typo: Suppleis.
> 
Thanks for spotting the typos!

> > + * @len: Supplies the length of @data.
> > + * @offset: unused.
> > + *
> > + * Return:
> > + * * >0	- Success, Length of buffer written
> > + * * <0	- Error
> > + */
> > +static ssize_t new_policy(struct file *f, const char __user *data,
> > +			  size_t len, loff_t *offset)
> > +{
> > +	int rc = 0;
> > +	char *copy = NULL;
> > +	struct ipe_policy *p = NULL;
> > +
> > +	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
> > +		return -EPERM;
> > +
> > +	copy = memdup_user_nul(data, len);
> > +	if (IS_ERR(copy)) {
> > +		rc = PTR_ERR(copy);
> > +		goto err;
> > +	}
> > +
> > +	p = ipe_new_policy(NULL, 0, copy, len);
> > +	if (IS_ERR(p)) {
> > +		rc = PTR_ERR(p);
> > +		goto err;
> > +	}
> > +
> > +	rc = ipe_new_policyfs_node(p);
> > +	if (rc)
> > +		goto err;
> 
> Uhm, don't you need to do cleanup of allocated memory or revert the
> actions of ipe_new_policy()?
> 
Yes that should be cleaned up but should be done in ipe_new_policy instead,
will add a ipe_free_policy call at the end. Thanks for pointing that out.

> 
> I would like more to see all the functions managing the policy
> together. If the patch is too long, you could further split by adding
> the helpers (that don't directly deal with the policy) in a separate
> patch.
> 
> Here you would simply instantiate dirs/files in securityfs and call the
> existing functions previously introduced.
> 
> Roberto
> 

I will try to split them in the next version. Thanks for the suggestion.
-Fan
