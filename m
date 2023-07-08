Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803D474BC30
	for <lists+linux-fscrypt@lfdr.de>; Sat,  8 Jul 2023 07:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbjGHFiD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 8 Jul 2023 01:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbjGHFha (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 8 Jul 2023 01:37:30 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B94269A
        for <linux-fscrypt@vger.kernel.org>; Fri,  7 Jul 2023 22:37:01 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-635eb5b0320so16970036d6.3
        for <linux-fscrypt@vger.kernel.org>; Fri, 07 Jul 2023 22:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1688794620; x=1691386620;
        h=in-reply-to:references:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mRTut3OlHqKCWiM81ta7SjbBbT2KSyk5zN+hB2sD2J4=;
        b=T8iQ+dddv8itdTsndAZ+8dqj8A1P6zmK/5ww1ffgNYZFJ8N7sPBE5Okd3UWfpL9P6U
         DCnZOtUOvhUqObSjP4bjybp5PUZ0RU8Lu/cbXMHhKXLWXOv+Inevf67blcKSyvzfcnvW
         78TNHLHpSVvTATjOIB44tQoYi+HjS+oaxzw5FJJQtLj8V5rzDhFIPv/o98BKw5a7knP6
         NB74vkK9ig1S7erKdH3Emo1Jj9Hpmm7WDiWLF2+khj1l9MEJXd+bYaRWWNz6RSacqfFx
         USFTaGnlXZ3M//ahGa8v0t7KFWdbbL20SunCGMC+HG0KOt8qOrEN7yj3fe7SB5VOeo/q
         RMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688794620; x=1691386620;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mRTut3OlHqKCWiM81ta7SjbBbT2KSyk5zN+hB2sD2J4=;
        b=krju+grwKNqEAvoCIBOcpDbQ9EpNn9Wvd5Zmqwxn5h/ashyBcdIlozZFQvGba6eI7P
         zrI/zg9wHeOXfcwxo18UMqCwsb/p4qtovVU6D8tfsNmsZbzEBPFo+5u+J//ePrcgQyq9
         2ie5s7C9kwt82XuKzW8iataFHf5f1qTcEaIsUxkFzUIWUm8ER6dXP7YishyqLW/LpInh
         DOlsVRJK5pj219d9cwCyvc1CidMg4AmvArmnp5E5L3EKfMp20boQXvtVi1QKE7LfX/BD
         C1j8/gz8tWG2vm7ldsv51bvrgely5wsWaw8U5GBulSLlQ8rE1WRqJiepfsvY9UwOjqnt
         4Y6g==
X-Gm-Message-State: ABy/qLZrPWY2m+xdgrj8nVdSoOMJ+IoFZY4a6jPTVgeag9VCYW3aP1Ho
        4FIRV/Hzjsteq17Kkan/b9wu
X-Google-Smtp-Source: APBJJlHQS5XBlGZlR3aeI4P59arzhT77oU+85EVLNEDa/0Wxlnb/6yUwkLDjlhT0yg5nRtXN/pQPYw==
X-Received: by 2002:a0c:dc87:0:b0:62d:efa2:f19f with SMTP id n7-20020a0cdc87000000b0062defa2f19fmr6824435qvk.54.1688794620221;
        Fri, 07 Jul 2023 22:37:00 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id m6-20020a0cdb86000000b006362c5760f8sm2952625qvk.139.2023.07.07.22.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jul 2023 22:36:59 -0700 (PDT)
Date:   Sat, 08 Jul 2023 01:36:59 -0400
Message-ID: <59d0824741118eb63b8ced046f1741f4.paul@paul-moore.com>
From:   Paul Moore <paul@paul-moore.com>
To:     Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>,
        Fan Wu <wufan@linux.microsoft.com>
Subject: Re: [PATCH RFC v10 7/17] ipe: add userspace interface
References: <1687986571-16823-8-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-8-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> As is typical with LSMs, IPE uses securityfs as its interface with
> userspace. for a complete list of the interfaces and the respective
> inputs/outputs, please see the documentation under
> admin-guide/LSM/ipe.rst
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
>  security/ipe/Makefile    |   2 +
>  security/ipe/fs.c        | 101 ++++++++
>  security/ipe/fs.h        |  16 ++
>  security/ipe/ipe.c       |   3 +
>  security/ipe/ipe.h       |   2 +
>  security/ipe/policy.c    | 111 +++++++++
>  security/ipe/policy.h    |   9 +
>  security/ipe/policy_fs.c | 481 +++++++++++++++++++++++++++++++++++++++
>  8 files changed, 725 insertions(+)
>  create mode 100644 security/ipe/fs.c
>  create mode 100644 security/ipe/fs.h
>  create mode 100644 security/ipe/policy_fs.c

...

> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> index 4069ff075093..3e8e4a06a044 100644
> --- a/security/ipe/policy.c
> +++ b/security/ipe/policy.c
> @@ -7,9 +7,36 @@
>  #include <linux/verification.h>
>  
>  #include "ipe.h"
> +#include "eval.h"
> +#include "fs.h"
>  #include "policy.h"
>  #include "policy_parser.h"
>  
> +/* lock for synchronizing writers across ipe policy */
> +DEFINE_MUTEX(ipe_policy_lock);
> +
> +/**
> + * ver_to_u64 - Convert an internal ipe_policy_version to a u64.
> + * @p: Policy to extract the version from.
> + *
> + * Bits (LSB is index 0):
> + *	[48,32] -> Major
> + *	[32,16] -> Minor
> + *	[16, 0] -> Revision
> + *
> + * Return: u64 version of the embedded version structure.
> + */
> +static inline u64 ver_to_u64(const struct ipe_policy *const p)
> +{
> +	u64 r;
> +
> +	r = (((u64)p->parsed->version.major) << 32)
> +	  | (((u64)p->parsed->version.minor) << 16)
> +	  | ((u64)(p->parsed->version.rev));
> +
> +	return r;
> +}
> +
>  /**
>   * ipe_free_policy - Deallocate a given IPE policy.
>   * @p: Supplies the policy to free.
> @@ -21,6 +48,7 @@ void ipe_free_policy(struct ipe_policy *p)
>  	if (IS_ERR_OR_NULL(p))
>  		return;
>  
> +	ipe_del_policyfs_node(p);
>  	free_parsed_policy(p->parsed);
>  	if (!p->pkcs7)
>  		kfree(p->text);
> @@ -39,6 +67,65 @@ static int set_pkcs7_data(void *ctx, const void *data, size_t len,
>  	return 0;
>  }
>  
> +/**
> + * ipe_update_policy - parse a new policy and replace @old with it.

What does "@old" refer to?  I'm guessing you want to drop the "@".

> + * @root: Supplies a pointer to the securityfs inode saved the policy.
> + * @text: Supplies a pointer to the plain text policy.
> + * @textlen: Supplies the length of @text.
> + * @pkcs7: Supplies a pointer to a buffer containing a pkcs7 message.
> + * @pkcs7len: Supplies the length of @pkcs7len.
> + *
> + * @text/@textlen is mutually exclusive with @pkcs7/@pkcs7len - see
> + * ipe_new_policy.
> + *
> + * Return:
> + * * !IS_ERR	- The old policy

"The old policy" is what?

> + * * -ENOENT	- Policy doesn't exist
> + * * -EINVAL	- New policy is invalid
> + */
> +struct ipe_policy *ipe_update_policy(struct inode *root,
> +				     const char *text, size_t textlen,
> +				     const char *pkcs7, size_t pkcs7len)
> +{
> +	int rc = 0;
> +	struct ipe_policy *old, *ap, *new = NULL;
> +
> +	lockdep_assert_held(&ipe_policy_lock);
> +
> +	old = (struct ipe_policy *)root->i_private;
> +	if (!old)
> +		return ERR_PTR(-ENOENT);
> +
> +	new = ipe_new_policy(text, textlen, pkcs7, pkcs7len);
> +	if (IS_ERR(new))
> +		return new;
> +
> +	if (strcmp(new->parsed->name, old->parsed->name)) {
> +		rc = -EINVAL;
> +		goto err;
> +	}
> +
> +	if (ver_to_u64(old) > ver_to_u64(new)) {
> +		rc = -EINVAL;
> +		goto err;
> +	}
> +
> +	root->i_private = new;
> +
> +	ap = rcu_dereference_protected(ipe_active_policy,
> +				       lockdep_is_held(&ipe_policy_lock));
> +	if (old == ap)
> +		rcu_assign_pointer(ipe_active_policy, new);
> +
> +	swap(new->policyfs, old->policyfs);

We don't have to worry about @new, but is there a guarantee that this
function is the only one attempting to modify @old?

*EDIT*: I found that @root is locked by the caller, that's good.  I
would suggest adding this assumption/requirement to the function's
description.  In general whenever a function requires something from
a caller it should be documented in the function's description.

> +out:
> +	return (rc < 0) ? ERR_PTR(rc) : old;
> +err:
> +	ipe_free_policy(new);
> +	goto out;
> +}
> +

...

> diff --git a/security/ipe/policy_fs.c b/security/ipe/policy_fs.c
> new file mode 100644
> index 000000000000..52a120118cda
> --- /dev/null
> +++ b/security/ipe/policy_fs.c
> @@ -0,0 +1,481 @@

...

> +/**
> + * getactive - Read handler for "ipe/policies/$name/active".
> + * @f: Supplies a file structure representing the securityfs node.
> + * @data: Suppleis a buffer passed to the write syscall.
> + * @len: Supplies the length of @data.
> + * @offset: unused.
> + *
> + * @data will be populated with the 1 or 0 depending on if the
> + * corresponding policy is active.
> + *
> + * Return:
> + * * >0	- Success, Length of buffer written
> + * * <0	- Error
> + */
> +static ssize_t getactive(struct file *f, char __user *data,
> +			 size_t len, loff_t *offset)
> +{
> +	int rc = 0;
> +	const char *str;
> +	struct inode *root = NULL;
> +	const struct ipe_policy *p = NULL;
> +
> +	root = d_inode(f->f_path.dentry->d_parent);
> +
> +	inode_lock_shared(root);
> +	p = (struct ipe_policy *)root->i_private;
> +	if (!p) {
> +		inode_unlock_shared(root);
> +		return -ENOENT;
> +	}
> +	inode_unlock_shared(root);
> +
> +	str = (p == rcu_access_pointer(ipe_active_policy)) ? "1" : "0";

The line above should be wrapped with a RCU lock.

> +	rc = simple_read_from_buffer(data, len, offset, str, 1);
> +
> +	return rc;
> +}

--
paul-moore.com
