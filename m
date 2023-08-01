Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6EA276BDA4
	for <lists+linux-fscrypt@lfdr.de>; Tue,  1 Aug 2023 21:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbjHATYm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 1 Aug 2023 15:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjHATYl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 1 Aug 2023 15:24:41 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15D519A4
        for <linux-fscrypt@vger.kernel.org>; Tue,  1 Aug 2023 12:24:38 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-5860c7fc2fcso31930987b3.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 01 Aug 2023 12:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1690917878; x=1691522678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=38Ojwrgj40lNrH18lDVNz7f8CEUxvzjuVRkkOoVXi3c=;
        b=FS/8h/9QzkAddpIc38jBNvvPbArN96+sXWtLNK/4pkm13UJ56T2KD+wfeAKTqoc4W1
         XON7LzvI5jz/vOYvYEBTVotH0nd6wHWMEpwyYXjDunvslDbIMQ1qPllyqFb1MfrhD48o
         SPYc5DhdVv7/cYXbSTlG7ZQidTCJf4aRUDNw9fZmOsSz4qK8HOlJ/AsF8J2ZrS2n72Kg
         WlG/Xn/L202hOOJQfPPkUPsqzbGMpsqAoYOleIQhIb8XjxQxPyA+UUDRltjbVov0h+RB
         DDuxtZ92JNeRUoJ0RlXwoT4BybrdDncvjxlzgmk7XItcAWCi/6TkP490V8LPF4DUTwDS
         iKnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690917878; x=1691522678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=38Ojwrgj40lNrH18lDVNz7f8CEUxvzjuVRkkOoVXi3c=;
        b=OHO8KijvXBdIuJ7fMuTFk1xZN9AS4yqjnraNQsxZ8Na3JlJ1ojXBbVmNbQKERUYNWf
         PmWg7kqKRE5cfV6hHK1p3+Klwh95AoxtWyRH8Zq7YJ8GKs1mfHcnSbxmszNdUZT7mJeZ
         8iAEAdcsf5BKuuviiV0w8kYliAHabUTa+2oVDGclVgfKBWzKyJQ3ozgZHNs4CP7LI3Gb
         dx2jMoppF61sHVS+CNc4mNSg07DGwtHzTE5KxLop9bcHQdZaSONk3HQZa7RUKPSYyGdV
         T9/4WlEf4Z4WaRcBbvT/34/hg/idOnuG784a3eZwsjDVZdqqfTrtMB5yZsl/dtzuFdUt
         KXFA==
X-Gm-Message-State: ABy/qLa0SXBjbpxYhd5hjbqDup9yytsjg3j0MkB51GlFAUFt/gbwXV0Q
        7yVMgjJ2Rk9/FLQTsSZGtWwD7LDfv6/TrgEgP2Hj
X-Google-Smtp-Source: APBJJlGVYKkoAlJEdO/pA2Hefr1NaPY8FSCU4/fsSlYHcIHkSndbJ2o+KScsMucfbtmWKA8SCnBFfHX2BsJoBBMxDkE=
X-Received: by 2002:a25:ab07:0:b0:d0a:7e3:fa0 with SMTP id u7-20020a25ab07000000b00d0a07e30fa0mr12480978ybi.53.1690917878071;
 Tue, 01 Aug 2023 12:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <1687986571-16823-9-git-send-email-wufan@linux.microsoft.com>
 <ec09144af7c7109d8b457ceccd50ba7a.paul@paul-moore.com> <20230715035738.GG15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230715035738.GG15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 1 Aug 2023 15:24:27 -0400
Message-ID: <CAHC9VhR-NDzKk-9gPP531ktaacd2wrdh0aGv5GScDgwkcWpcsw@mail.gmail.com>
Subject: Re: [PATCH RFC v10 8/17] uapi|audit|ipe: add ipe auditing support
To:     Fan Wu <wufan@linux.microsoft.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jul 14, 2023 at 11:57=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com>=
 wrote:
> On Sat, Jul 08, 2023 at 12:23:05AM -0400, Paul Moore wrote:
> > On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > >
> > > Users of IPE require a way to identify when and why an operation fail=
s,
> > > allowing them to both respond to violations of policy and be notified
> > > of potentially malicious actions on their systems with respect to IPE
> > > itself.
> > >
> > > This patch introduces 3 new audit events.
> > >
> > > AUDIT_IPE_ACCESS(1420) indicates the result of an IPE policy evaluati=
on
> > > of a resource.
> > > AUDIT_IPE_CONFIG_CHANGE(1421) indicates the current active IPE policy
> > > has been changed to another loaded policy.
> > > AUDIT_IPE_POLICY_LOAD(1422) indicates a new IPE policy has been loade=
d
> > > into the kernel.
> > >
> > > This patch also adds support for success auditing, allowing users to
> > > identify why an allow decision was made for a resource. However, it i=
s
> > > recommended to use this option with caution, as it is quite noisy.
> > >
> > > Here are some examples of the new audit record types:
> > >
> > > AUDIT_IPE_ACCESS(1420):
> > >
> > >     audit: AUDIT1420 path=3D"/root/vol/bin/hello" dev=3D"sda"
> > >       ino=3D3897 rule=3D"op=3DEXECUTE boot_verified=3DTRUE action=3DA=
LLOW"
> >
> > The 'dev' field is already in use by audit, and is used to log the
> > device major and minor numbers, see audit_log_name() for an example.
> >
> > I would suggest adopting the existing 'dev' field format, but if you
> > really want to log the device name as a string you will need to find
> > another audit field name.
>
> Actually it was copied from https://git.kernel.org/pub/scm/linux/kernel/g=
it/torvalds/linux.git/tree/security/lsm_audit.c#n228
> Personally I think using device name is better, I will try to add a new f=
ield.

Ha, yes, it does look like the LSM code uses the device name as
opposed to the major:minor format.  Given that existing use, and that
IPE is a LSM, sticking with 'dev=3D<name>' seems like the right thing to
do.  Sorry about that :/

> > >     audit: AUDIT1420 path=3D"/mnt/ipe/bin/hello" dev=3D"dm-0"
> > >       ino=3D2 rule=3D"DEFAULT action=3DDENY"
> > >
> > >     audit: AUDIT1420 path=3D"/tmp/tmpdp2h1lub/deny/bin/hello" dev=3D"=
tmpfs"
> > >       ino=3D131 rule=3D"DEFAULT action=3DDENY"
> > >
> > > The above three records were generated when the active IPE policy onl=
y
> > > allows binaries from the initial booted drive(sda) to run. The three
> > > identical `hello` binary were placed at different locations, only the
> > > first hello from sda was allowed.
> > >
> > > Field path followed by the file's path name.
> > >
> > > Field dev followed by the device name as found in /dev where the file=
 is
> > > from.
> > > Note that for device mappers it will use the name `dm-X` instead of
> > > the name in /dev/mapper.
> > > For a file in a temp file system, which is not from a device, it will=
 use
> > > `tmpfs` for the field.
> > > The implementation of this part is following another existing use cas=
e
> > > LSM_AUDIT_DATA_INODE in security/lsm_audit.c
> > >
> > > Field ino followed by the file's inode number.
> > >
> > > Field rule followed by the IPE rule made the access decision. The who=
le
> > > rule must be audited because the decision is based on the combination=
 of
> > > all property conditions in the rule.
> > >
> > > Along with the syscall audit event, user can know why a blocked
> > > happened. For example:
> > >
> > >     audit: AUDIT1420 path=3D"/mnt/ipe/bin/hello" dev=3D"dm-0"
> > >       ino=3D2 rule=3D"DEFAULT action=3DDENY"
> > >     audit[1956]: SYSCALL arch=3Dc000003e syscall=3D59
> > >       success=3Dno exit=3D-13 a0=3D556790138df0 a1=3D556790135390 a2=
=3D5567901338b0
> > >       a3=3Dab2a41a67f4f1f4e items=3D1 ppid=3D147 pid=3D1956 auid=3D42=
94967295 uid=3D0
> > >       gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0=
 tty=3Dpts0
> > >       ses=3D4294967295 comm=3D"bash" exe=3D"/usr/bin/bash" key=3D(nul=
l)
> > >
> > > The above two records showed bash used execve to run "hello" and got
> > > blocked by IPE. Note that the IPE records are always prior to a SYSCA=
LL
> > > record.
> > >
> > > AUDIT_IPE_CONFIG_CHANGE(1421):
> > >
> > >     audit: AUDIT1421
> > >       old_active_pol_name=3D"Allow_All" old_active_pol_version=3D0.0.=
0
> > >       old_policy_digest=3Dsha256:E3B0C44298FC1C149AFBF4C8996FB92427AE=
41E4649B934CA495991B7852B855
> > >       new_active_pol_name=3D"boot_verified" new_active_pol_version=3D=
0.0.0
> > >       new_policy_digest=3Dsha256:820EEA5B40CA42B51F68962354BA083122A2=
0BB846F26765076DD8EED7B8F4DB
> > >       auid=3D4294967295 ses=3D4294967295 lsm=3Dipe res=3D1
> >
> > You can trim hash digest strings so they better fit in terminals, for
> > example:
> >
> >   old_policy_digest=3Dsha256:E3B0C44....
>
> Do you mean I could trim it in the documentation and for the real audit
> record I still record the whole hash?

Yes.  Failure to record the full hash digest string in the record
would be Very Bad, but for the sake of keeping the line lengths in the
docs and commit description reasonable you can trim as necessary.
After all, we all know what a full hash string looks like :)

> > > The above record showed the current IPE active policy switch from
> > > `Allow_All` to `boot_verified` along with the version and the hash
> > > digest of the two policies. Note IPE can only have one policy active
> > > at a time, all access decision evaluation is based on the current act=
ive
> > > policy.
> > > The normal procedure to deploy a policy is loading the policy to depl=
oy
> > > into the kernel first, then switch the active policy to it.
> > >
> > > AUDIT_IPE_POLICY_LOAD(1422):
> > >
> > > audit: AUDIT1422 policy_name=3D"boot_verified" policy_version=3D0.0.0
> > > policy_digest=3Dsha256:820EEA5B40CA42B51F68962354BA083122A20BB846F267=
65076DD8EED7B8F4DB
> > > auid=3D4294967295 ses=3D4294967295 lsm=3Dipe res=3D1
> > >
> > > The above record showed a new policy has been loaded into the kernel
> > > with the policy name, policy version and policy hash.
> > >
> > > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > > ---
> > >  include/uapi/linux/audit.h |   3 +
> > >  security/ipe/Kconfig       |   2 +-
> > >  security/ipe/Makefile      |   1 +
> > >  security/ipe/audit.c       | 197 +++++++++++++++++++++++++++++++++++=
++
> > >  security/ipe/audit.h       |  18 ++++
> > >  security/ipe/eval.c        |  26 ++++-
> > >  security/ipe/eval.h        |   8 ++
> > >  security/ipe/fs.c          |  71 +++++++++++++
> > >  security/ipe/policy.c      |   5 +
> > >  9 files changed, 327 insertions(+), 4 deletions(-)
> > >  create mode 100644 security/ipe/audit.c
> > >  create mode 100644 security/ipe/audit.h

...

> > > +/**
> > > + * ipe_audit_match - audit a match for IPE policy.
> > > + * @ctx: Supplies a pointer to the evaluation context that was used =
in the
> > > + *  evaluation.
> > > + * @match_type: Supplies the scope of the match: rule, operation def=
ault,
> > > + *         global default.
> > > + * @act: Supplies the IPE's evaluation decision, deny or allow.
> > > + * @r: Supplies a pointer to the rule that was matched, if possible.
> > > + * @enforce: Supplies the enforcement/permissive state at the point
> > > + *      the enforcement decision was made.
> > > + */
> > > +void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
> > > +                enum ipe_match match_type,
> > > +                enum ipe_action_type act, const struct ipe_rule *con=
st r)
> > > +{
> > > +   struct inode *inode;
> > > +   struct audit_buffer *ab;
> > > +   const char *op =3D audit_op_names[ctx->op];
> > > +
> > > +   if (act !=3D __IPE_ACTION_DENY && !READ_ONCE(success_audit))
> > > +           return;
> > > +
> > > +   ab =3D audit_log_start(audit_context(), GFP_KERNEL, AUDIT_IPE_ACC=
ESS);
> > > +   if (!ab)
> > > +           return;
> > > +
> > > +   if (ctx->file) {
> > > +           audit_log_d_path(ab, "path=3D", &ctx->file->f_path);
> > > +           inode =3D file_inode(ctx->file);
> > > +           if (inode) {
> > > +                   audit_log_format(ab, " dev=3D");
> > > +                   audit_log_untrustedstring(ab, inode->i_sb->s_id);
> >
> > See my comments above about using the 'dev' field name, however, you
> > shouldn't need to log the device name as an untrusted string as the
> > string is coming from a trusted source within the kernel (the driver).
>
> I was trying to follow the existing code at https://git.kernel.org/pub/sc=
m/linux/kernel/git/torvalds/linux.git/tree/security/lsm_audit.c#n229
> But I do agree as it is already in the kernel, it should be trusted.

Hmm.  Given the existing code, I guess stick with the untrusted string
variant for now.  I'm concerned that there is some device naming code
which might allow funky device names; although if you can prove that
is not the case then you can use the normal audit logging functions.

For reference, the characters that audit finds problematic can be
found in audit_string_contains_control().

--=20
paul-moore.com
