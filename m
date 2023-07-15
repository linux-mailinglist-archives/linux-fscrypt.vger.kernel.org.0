Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552E3754681
	for <lists+linux-fscrypt@lfdr.de>; Sat, 15 Jul 2023 05:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjGOD0r (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 14 Jul 2023 23:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjGOD0q (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 14 Jul 2023 23:26:46 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5456F35AA;
        Fri, 14 Jul 2023 20:26:45 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id B822021C4693; Fri, 14 Jul 2023 20:26:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B822021C4693
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1689391604;
        bh=uHlf75Div8mbLFgAGmoIhLsDxBVNzT1+8eAHLZNdd7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gi+aRl0SZqeMF0TJzMJC2yxDI7aKDbisnyJxYJJydfc8WLZF7iyMQNz8014HRBFX2
         SbJtruH/3DrYYWOMfLkGjGI3LRRWCLTIdgOljRHXhgBD5z4gEZ0SjjRFlI2tJXddpe
         gFky4eZxEs250wNruoVUgMnltH3EURKo7kPyMrNY=
Date:   Fri, 14 Jul 2023 20:26:44 -0700
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [PATCH RFC v10 7/17] ipe: add userspace interface
Message-ID: <20230715032644.GF15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-8-git-send-email-wufan@linux.microsoft.com>
 <fcc5de3f153eb60b5acf799c159e6ec8.paul@paul-moore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcc5de3f153eb60b5acf799c159e6ec8.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Jul 08, 2023 at 12:23:04AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > As is typical with LSMs, IPE uses securityfs as its interface with
> > userspace. for a complete list of the interfaces and the respective
> > inputs/outputs, please see the documentation under
> > admin-guide/LSM/ipe.rst
> > 
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  security/ipe/Makefile    |   2 +
> >  security/ipe/fs.c        | 101 ++++++++
> >  security/ipe/fs.h        |  16 ++
> >  security/ipe/ipe.c       |   3 +
> >  security/ipe/ipe.h       |   2 +
> >  security/ipe/policy.c    | 111 +++++++++
> >  security/ipe/policy.h    |   9 +
> >  security/ipe/policy_fs.c | 481 +++++++++++++++++++++++++++++++++++++++
> >  8 files changed, 725 insertions(+)
> >  create mode 100644 security/ipe/fs.c
> >  create mode 100644 security/ipe/fs.h
> >  create mode 100644 security/ipe/policy_fs.c
> 
> ...
> 
> > diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> > index 4069ff075093..3e8e4a06a044 100644
> > --- a/security/ipe/policy.c
> > +++ b/security/ipe/policy.c
> > @@ -7,9 +7,36 @@
> >  #include <linux/verification.h>
> >  
> >  #include "ipe.h"
> > +#include "eval.h"
> > +#include "fs.h"
> >  #include "policy.h"
> >  #include "policy_parser.h"
> >  
> > +/* lock for synchronizing writers across ipe policy */
> > +DEFINE_MUTEX(ipe_policy_lock);
> > +
> > +/**
> > + * ver_to_u64 - Convert an internal ipe_policy_version to a u64.
> > + * @p: Policy to extract the version from.
> > + *
> > + * Bits (LSB is index 0):
> > + *	[48,32] -> Major
> > + *	[32,16] -> Minor
> > + *	[16, 0] -> Revision
> > + *
> > + * Return: u64 version of the embedded version structure.
> > + */
> > +static inline u64 ver_to_u64(const struct ipe_policy *const p)
> > +{
> > +	u64 r;
> > +
> > +	r = (((u64)p->parsed->version.major) << 32)
> > +	  | (((u64)p->parsed->version.minor) << 16)
> > +	  | ((u64)(p->parsed->version.rev));
> > +
> > +	return r;
> > +}
> > +
> >  /**
> >   * ipe_free_policy - Deallocate a given IPE policy.
> >   * @p: Supplies the policy to free.
> > @@ -21,6 +48,7 @@ void ipe_free_policy(struct ipe_policy *p)
> >  	if (IS_ERR_OR_NULL(p))
> >  		return;
> >  
> > +	ipe_del_policyfs_node(p);
> >  	free_parsed_policy(p->parsed);
> >  	if (!p->pkcs7)
> >  		kfree(p->text);
> > @@ -39,6 +67,65 @@ static int set_pkcs7_data(void *ctx, const void *data, size_t len,
> >  	return 0;
> >  }
> >  
> > +/**
> > + * ipe_update_policy - parse a new policy and replace @old with it.
> 
> What does "@old" refer to?  I'm guessing you want to drop the "@".
> 
Yes it shouldn't be here, sorry confusion.

> > + * @root: Supplies a pointer to the securityfs inode saved the policy.
> > + * @text: Supplies a pointer to the plain text policy.
> > + * @textlen: Supplies the length of @text.
> > + * @pkcs7: Supplies a pointer to a buffer containing a pkcs7 message.
> > + * @pkcs7len: Supplies the length of @pkcs7len.
> > + *
> > + * @text/@textlen is mutually exclusive with @pkcs7/@pkcs7len - see
> > + * ipe_new_policy.
> > + *
> > + * Return:
> > + * * !IS_ERR	- The old policy
> 
> "The old policy" is what?
> 
Let me try to pharse it in another way, how about the existing policy
saved in the inode before update?

> > + * * -ENOENT	- Policy doesn't exist
> > + * * -EINVAL	- New policy is invalid
> > + */
> > +struct ipe_policy *ipe_update_policy(struct inode *root,
> > +				     const char *text, size_t textlen,
> > +				     const char *pkcs7, size_t pkcs7len)
> > +{
> > +	int rc = 0;
> > +	struct ipe_policy *old, *ap, *new = NULL;
> > +
> > +	lockdep_assert_held(&ipe_policy_lock);
> > +
> > +	old = (struct ipe_policy *)root->i_private;
> > +	if (!old)
> > +		return ERR_PTR(-ENOENT);
> > +
> > +	new = ipe_new_policy(text, textlen, pkcs7, pkcs7len);
> > +	if (IS_ERR(new))
> > +		return new;
> > +
> > +	if (strcmp(new->parsed->name, old->parsed->name)) {
> > +		rc = -EINVAL;
> > +		goto err;
> > +	}
> > +
> > +	if (ver_to_u64(old) > ver_to_u64(new)) {
> > +		rc = -EINVAL;
> > +		goto err;
> > +	}
> > +
> > +	root->i_private = new;
> > +
> > +	ap = rcu_dereference_protected(ipe_active_policy,
> > +				       lockdep_is_held(&ipe_policy_lock));
> > +	if (old == ap)
> > +		rcu_assign_pointer(ipe_active_policy, new);
> > +
> > +	swap(new->policyfs, old->policyfs);
> 
> We don't have to worry about @new, but is there a guarantee that this
> function is the only one attempting to modify @old?
> 
> *EDIT*: I found that @root is locked by the caller, that's good.  I
> would suggest adding this assumption/requirement to the function's
> description.  In general whenever a function requires something from
> a caller it should be documented in the function's description.
> 
Sorry I missed that, I will add the locking assumption in the description.
Also, just found the err part below might better be replaced by return.

> > +out:
> > +	return (rc < 0) ? ERR_PTR(rc) : old;
> > +err:
> > +	ipe_free_policy(new);
> > +	goto out;
> > +}
> > +
> 
> ...
> 
> > diff --git a/security/ipe/policy_fs.c b/security/ipe/policy_fs.c
> > new file mode 100644
> > index 000000000000..52a120118cda
> > --- /dev/null
> > +++ b/security/ipe/policy_fs.c
> > @@ -0,0 +1,481 @@
> 
> ...
> 
> > +/**
> > + * getactive - Read handler for "ipe/policies/$name/active".
> > + * @f: Supplies a file structure representing the securityfs node.
> > + * @data: Suppleis a buffer passed to the write syscall.
> > + * @len: Supplies the length of @data.
> > + * @offset: unused.
> > + *
> > + * @data will be populated with the 1 or 0 depending on if the
> > + * corresponding policy is active.
> > + *
> > + * Return:
> > + * * >0	- Success, Length of buffer written
> > + * * <0	- Error
> > + */
> > +static ssize_t getactive(struct file *f, char __user *data,
> > +			 size_t len, loff_t *offset)
> > +{
> > +	int rc = 0;
> > +	const char *str;
> > +	struct inode *root = NULL;
> > +	const struct ipe_policy *p = NULL;
> > +
> > +	root = d_inode(f->f_path.dentry->d_parent);
> > +
> > +	inode_lock_shared(root);
> > +	p = (struct ipe_policy *)root->i_private;
> > +	if (!p) {
> > +		inode_unlock_shared(root);
> > +		return -ENOENT;
> > +	}
> > +	inode_unlock_shared(root);
> > +
> > +	str = (p == rcu_access_pointer(ipe_active_policy)) ? "1" : "0";
> 
> The line above should be wrapped with a RCU lock.
> 
This call only checks the value inside the pointer but doesn't dereference it.
Also from https://lwn.net/Articles/652156/ I found it says "The call to
rcu_access_pointer() need not be protected. In contrast, rcu_dereference() must
either be within an RCU read-side critical section", so I didn't add the lock
here, is this article outdated?

Thanks,
-Fan
> > +	rc = simple_read_from_buffer(data, len, offset, str, 1);
> > +
> > +	return rc;
> > +}
> 
> --
> paul-moore.com
