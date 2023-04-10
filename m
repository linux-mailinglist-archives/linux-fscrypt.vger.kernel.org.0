Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D455A6DCB59
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Apr 2023 21:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjDJTKm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 15:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDJTKm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 15:10:42 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAAC21BC0;
        Mon, 10 Apr 2023 12:10:35 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 36F172174E2A; Mon, 10 Apr 2023 12:10:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 36F172174E2A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1681153835;
        bh=LitfwmASCD6XtrcgTnTIIPBcVPikllBf+qN/GfqwP8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GOMIdjecPKY/CPgp3Hfb8d0/as17ALZ4feRwVik4YxfTblNlTUL+lnjqlAW6134lu
         Urxyg0gve4p23SRx8ZvktUXNuHLxvME7Zv/VBDQ6XcS/44WG4NlPINI2DOUkJV08qN
         /oxfY2MKMlvmrozaEbOwKupq23Mu/E/s+h90LTgo=
Date:   Mon, 10 Apr 2023 12:10:35 -0700
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 05/16] ipe: add userspace interface
Message-ID: <20230410191035.GB18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRa+NwKzLfQBmHfMgUp6_d5soQG7JBq-Vn=MUeUAt4tuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRa+NwKzLfQBmHfMgUp6_d5soQG7JBq-Vn=MUeUAt4tuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-17.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 02, 2023 at 02:04:42PM -0500, Paul Moore wrote:
> On Mon, Jan 30, 2023 at 5:58???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> >
> > From: Deven Bowers <deven.desai@linux.microsoft.com>
> >
> > As is typical with LSMs, IPE uses securityfs as its interface with
> > userspace. for a complete list of the interfaces and the respective
> > inputs/outputs, please see the documentation under
> > admin-guide/LSM/ipe.rst
> >
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> 
> ...
> 
> > ---
> >  security/ipe/Makefile    |   2 +
> >  security/ipe/fs.c        | 101 +++++++++
> >  security/ipe/fs.h        |  17 ++
> >  security/ipe/ipe.c       |   3 +
> >  security/ipe/ipe.h       |   2 +
> >  security/ipe/policy.c    | 135 ++++++++++++
> >  security/ipe/policy.h    |   7 +
> >  security/ipe/policy_fs.c | 459 +++++++++++++++++++++++++++++++++++++++
> >  8 files changed, 726 insertions(+)
> >  create mode 100644 security/ipe/fs.c
> >  create mode 100644 security/ipe/fs.h
> >  create mode 100644 security/ipe/policy_fs.c
> 
> ...
> 
> > diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> > index 772d876b1087..a5e9c6e5691b 100644
> > --- a/security/ipe/policy.c
> > +++ b/security/ipe/policy.c
> > @@ -4,12 +4,39 @@
> >   */
> >
> >  #include "ipe.h"
> > +#include "eval.h"
> > +#include "fs.h"
> >  #include "policy.h"
> >  #include "policy_parser.h"
> >  #include "digest.h"
> >
> >  #include <linux/verification.h>
> >
> > +/* lock for synchronizing writers across ipe policy */
> > +DEFINE_SPINLOCK(ipe_policy_lock);
> > +
> > +/**
> > + * ver_to_u64 - Convert an internal ipe_policy_version to a u64.
> > + * @p: Policy to extract the version from.
> > + *
> > + * Bits (LSB is index 0):
> > + *     [48,32] -> Major
> > + *     [32,16] -> Minor
> > + *     [16, 0] -> Revision
> > + *
> > + * Return: u64 version of the embedded version structure.
> > + */
> > +static inline u64 ver_to_u64(const struct ipe_policy *const p)
> > +{
> > +       u64 r = 0;
> 
> No need to set @r to 0 since you set it to the version immediately below.
> 

Yes this is redundant, I will remove it.

> > +       r = (((u64)p->parsed->version.major) << 32)
> > +         | (((u64)p->parsed->version.minor) << 16)
> > +         | ((u64)(p->parsed->version.rev));
> > +
> > +       return r;
> > +}
> > +
> >  /**
> >   * ipe_free_policy - Deallocate a given IPE policy.
> >   * @p: Supplies the policy to free.
> > @@ -21,6 +48,7 @@ void ipe_free_policy(struct ipe_policy *p)
> >         if (IS_ERR_OR_NULL(p))
> >                 return;
> >
> > +       ipe_del_policyfs_node(p);
> >         free_parsed_policy(p->parsed);
> >         if (!p->pkcs7)
> >                 kfree(p->text);
> > @@ -39,6 +67,70 @@ static int set_pkcs7_data(void *ctx, const void *data, size_t len,
> >         return 0;
> >  }
> >
> > +/**
> > + * ipe_update_policy - parse a new policy and replace @old with it.
> > + * @addr: Supplies a pointer to the i_private for saving policy.
> > + * @text: Supplies a pointer to the plain text policy.
> > + * @textlen: Supplies the length of @text.
> > + * @pkcs7: Supplies a pointer to a buffer containing a pkcs7 message.
> > + * @pkcs7len: Supplies the length of @pkcs7len.
> > + *
> > + * @text/@textlen is mutually exclusive with @pkcs7/@pkcs7len - see
> > + * ipe_new_policy.
> > + *
> > + * Return:
> > + * * !IS_ERR   - OK
> > + * * -ENOENT   - Policy doesn't exist
> > + * * -EINVAL   - New policy is invalid
> > + */
> > +struct ipe_policy *ipe_update_policy(struct ipe_policy __rcu **addr,
> > +                                    const char *text, size_t textlen,
> > +                                    const char *pkcs7, size_t pkcs7len)
> > +{
> > +       int rc = 0;
> > +       struct ipe_policy *old, *new;
> > +
> > +       old = ipe_get_policy_rcu(*addr);
> > +       if (!old) {
> > +               rc = -ENOENT;
> > +               goto err;
> > +       }
> > +
> > +       new = ipe_new_policy(text, textlen, pkcs7, pkcs7len);
> > +       if (IS_ERR(new)) {
> > +               rc = PTR_ERR(new);
> > +               goto err;
> > +       }
> > +
> > +       if (strcmp(new->parsed->name, old->parsed->name)) {
> > +               rc = -EINVAL;
> > +               goto err;
> > +       }
> > +
> > +       if (ver_to_u64(old) > ver_to_u64(new)) {
> > +               rc = -EINVAL;
> > +               goto err;
> > +       }
> > +
> > +       if (ipe_is_policy_active(old)) {
> 
> I don't understand the is-active check, you want to make @new the new
> active policy regardless, right?  Could this is-active check ever be
> false?
> 

Actually this is needed. Policy updates can be applied to any deployed
policy, which may be saved in two places: the securityfs file node
and the ipe_active_policy pointer. To update a policy, this function first
checks if the policy saved in the securityfs file node is currently active.
If so, it updates the ipe_active_policy pointer to point to the new policy,
and finally updates the policy pointer in the securityfs to the new policy.

-Fan

> > +               spin_lock(&ipe_policy_lock);
> > +               rcu_assign_pointer(ipe_active_policy, new);
> > +               spin_unlock(&ipe_policy_lock);
> > +               synchronize_rcu();
> > +       }
> > +
> > +       rcu_assign_pointer(*addr, new);
> > +
> > +       swap(new->policyfs, old->policyfs);
> > +       ipe_free_policy(old);
> > +
> > +       goto out;
> > +err:
> > +       ipe_free_policy(new);
> > +out:
> > +       return (rc < 0) ? ERR_PTR(rc) : new;
> > +}
> > +
> >  /**
> >   * ipe_new_policy - Allocate and parse an ipe_policy structure.
> >   *
> > @@ -117,3 +209,46 @@ struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p)
> >
> >         return rv;
> >  }
> > +
> > +/**
> > + * ipe_set_active_pol - Make @p the active policy.
> > + * @p: Supplies a pointer to the policy to make active.
> > + */
> > +int ipe_set_active_pol(const struct ipe_policy *p)
> > +{
> > +       int rc = 0;
> > +       struct ipe_policy *ap = NULL;
> > +
> > +       ap = ipe_get_policy_rcu(ipe_active_policy);
> > +       if (ap && ver_to_u64(ap) > ver_to_u64(p)) {
> > +               rc = -EINVAL;
> > +               goto out;
> > +       }
> > +
> > +       spin_lock(&ipe_policy_lock);
> > +       rcu_assign_pointer(ipe_active_policy, p);
> > +       spin_unlock(&ipe_policy_lock);
> > +       synchronize_rcu();
> > +
> > +out:
> > +       return rc;
> > +}
> > +
> > +/**
> > + * ipe_is_policy_active - Determine wehther @p is the active policy.
> > + * @p: Supplies a pointer to the policy to check.
> > + *
> > + * Return:
> > + * * true      - @p is the active policy
> > + * * false     - @p is not the active policy
> > + */
> > +bool ipe_is_policy_active(const struct ipe_policy *p)
> > +{
> > +       bool rv;
> > +
> > +       rcu_read_lock();
> > +       rv = rcu_access_pointer(ipe_active_policy) == p;
> > +       rcu_read_unlock();
> > +
> > +       return rv;
> > +}
> 
> --
> paul-moore.com
