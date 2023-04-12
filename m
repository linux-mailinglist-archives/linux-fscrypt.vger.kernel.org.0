Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40F46E0298
	for <lists+linux-fscrypt@lfdr.de>; Thu, 13 Apr 2023 01:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjDLXgM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 12 Apr 2023 19:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDLXgL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 12 Apr 2023 19:36:11 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07DE419BE;
        Wed, 12 Apr 2023 16:36:07 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 7CD3D21779D8; Wed, 12 Apr 2023 16:36:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7CD3D21779D8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1681342566;
        bh=YPXWa/7TYeGcUcrSe6JmCqFPK2vN2hRqkpxy8Lf9hp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YuvgGUEjnvrbLnB0mThO0/tNDZ+pzM/L8mr1DVspNRj6O+y0N8B/6epPpbYWZWjbK
         G1mzu0i9tJ7cZl4x+x8Od4BO0L1b9Enskrn3H6DdyL1bIL3S4RtVPsZ/KFIcIROYQZ
         0JLI4PQ8S0LdHkBOtrPDOXTqszDAjnr9JhbX5NBs=
Date:   Wed, 12 Apr 2023 16:36:06 -0700
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
Message-ID: <20230412233606.GA16658@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRa+NwKzLfQBmHfMgUp6_d5soQG7JBq-Vn=MUeUAt4tuQ@mail.gmail.com>
 <20230410191035.GB18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhQDvWDshaZvJrHmjcwyHFxv9oYTN9bn0xiTtFZQRp+GPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQDvWDshaZvJrHmjcwyHFxv9oYTN9bn0xiTtFZQRp+GPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Apr 11, 2023 at 05:45:41PM -0400, Paul Moore wrote:
> On Mon, Apr 10, 2023 at 3:10???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > On Thu, Mar 02, 2023 at 02:04:42PM -0500, Paul Moore wrote:
> > > On Mon, Jan 30, 2023 at 5:58???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > > >
> > > > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > > >
> > > > As is typical with LSMs, IPE uses securityfs as its interface with
> > > > userspace. for a complete list of the interfaces and the respective
> > > > inputs/outputs, please see the documentation under
> > > > admin-guide/LSM/ipe.rst
> > > >
> > > > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > > > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > >
> > > ...
> > >
> > > > ---
> > > >  security/ipe/Makefile    |   2 +
> > > >  security/ipe/fs.c        | 101 +++++++++
> > > >  security/ipe/fs.h        |  17 ++
> > > >  security/ipe/ipe.c       |   3 +
> > > >  security/ipe/ipe.h       |   2 +
> > > >  security/ipe/policy.c    | 135 ++++++++++++
> > > >  security/ipe/policy.h    |   7 +
> > > >  security/ipe/policy_fs.c | 459 +++++++++++++++++++++++++++++++++++++++
> > > >  8 files changed, 726 insertions(+)
> > > >  create mode 100644 security/ipe/fs.c
> > > >  create mode 100644 security/ipe/fs.h
> > > >  create mode 100644 security/ipe/policy_fs.c
> 
> ...
> 
> > > > +/**
> > > > + * ipe_update_policy - parse a new policy and replace @old with it.
> > > > + * @addr: Supplies a pointer to the i_private for saving policy.
> > > > + * @text: Supplies a pointer to the plain text policy.
> > > > + * @textlen: Supplies the length of @text.
> > > > + * @pkcs7: Supplies a pointer to a buffer containing a pkcs7 message.
> > > > + * @pkcs7len: Supplies the length of @pkcs7len.
> > > > + *
> > > > + * @text/@textlen is mutually exclusive with @pkcs7/@pkcs7len - see
> > > > + * ipe_new_policy.
> > > > + *
> > > > + * Return:
> > > > + * * !IS_ERR   - OK
> > > > + * * -ENOENT   - Policy doesn't exist
> > > > + * * -EINVAL   - New policy is invalid
> > > > + */
> > > > +struct ipe_policy *ipe_update_policy(struct ipe_policy __rcu **addr,
> > > > +                                    const char *text, size_t textlen,
> > > > +                                    const char *pkcs7, size_t pkcs7len)
> > > > +{
> > > > +       int rc = 0;
> > > > +       struct ipe_policy *old, *new;
> > > > +
> > > > +       old = ipe_get_policy_rcu(*addr);
> > > > +       if (!old) {
> > > > +               rc = -ENOENT;
> > > > +               goto err;
> > > > +       }
> > > > +
> > > > +       new = ipe_new_policy(text, textlen, pkcs7, pkcs7len);
> > > > +       if (IS_ERR(new)) {
> > > > +               rc = PTR_ERR(new);
> > > > +               goto err;
> > > > +       }
> > > > +
> > > > +       if (strcmp(new->parsed->name, old->parsed->name)) {
> > > > +               rc = -EINVAL;
> > > > +               goto err;
> > > > +       }
> > > > +
> > > > +       if (ver_to_u64(old) > ver_to_u64(new)) {
> > > > +               rc = -EINVAL;
> > > > +               goto err;
> > > > +       }
> > > > +
> > > > +       if (ipe_is_policy_active(old)) {
> > >
> > > I don't understand the is-active check, you want to make @new the new
> > > active policy regardless, right?  Could this is-active check ever be
> > > false?
> >
> > Actually this is needed. Policy updates can be applied to any deployed
> > policy, which may be saved in two places: the securityfs file node
> > and the ipe_active_policy pointer. To update a policy, this function first
> > checks if the policy saved in the securityfs file node is currently active.
> > If so, it updates the ipe_active_policy pointer to point to the new policy,
> > and finally updates the policy pointer in the securityfs to the new policy.
> 
> Ah, okay.  I must have forgotten, or not realized, that multiple
> policies could be loaded and not active.
> 
> I guess this does make me wonder about keeping a non-active policy
> loaded in the kernel, what purpose does that serve?
> 

The non-active policy doesn't serve anything unless it is activated. User can
even delete a policy if that is no longer needed. Non-active is just the default
state when a new policy is loaded.

If IPE supports namespace, there is another use case where different containers
can select different policies as the active policy from among multiple loaded
policies. Deven has presented a demo of this during LSS 2021. But this goes
beyond the scope of this version.

-Fan

> -- 
> paul-moore.com
