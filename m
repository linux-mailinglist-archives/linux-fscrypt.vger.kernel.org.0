Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179A26DE7C5
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 Apr 2023 01:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjDKXIM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Apr 2023 19:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDKXIL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Apr 2023 19:08:11 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979BD173D
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 16:08:09 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id h198so16452359ybg.12
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 16:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1681254489; x=1683846489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eIyxfCRdtVW6DZEqESNyM82Zcjpw6q1yxE2SLi7Q/10=;
        b=XXnbf3ZXHmVyyAWosjbgtLtVe0obVxWMHT6ER5WKVjE2//n1kQT1vqGfH+itDlXM2k
         2fneTH+5x2uocctQ6SccdU559tW16dOAzYZt4SUNr3SQZoWWsatyRHmcKNDLHGZiFZX1
         ngNGr73HAG/JBY+0W9DmkWkoC+3V3vgClv7PS81c7UdnCx+3aMFz1Ishp4aKe2GcG+9q
         +3SRRyJSTGsRHSMejxxYLambtKEVZffeY9ZCgEkqByHxjKnrI4D7N/WlEOpBuqUt0lI4
         YOvKnY4/lPDxTBJnhmllQ0VSpmZ1AJLwV7aGqPZH7Infu2EyjgWnt0Qsp4/uyydvAv+I
         TYrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681254489; x=1683846489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eIyxfCRdtVW6DZEqESNyM82Zcjpw6q1yxE2SLi7Q/10=;
        b=j5K073g5edQ7PA3j+R4TG4RO0A5Hd5G5MYCDyghOHnlFYKzkNRhsuFK74wL7GuZGJS
         EB17FVq6LZMZHEosod3yJiOstxG8O7Ei17MUybj0hhQeDrCb7nIps9e69S+GTLhaZA95
         cy4p3WcTumnf4SjWmuhqCQh0Wt3p2LM45XaTmjoMc3+XVqxaB0EMLWtuXE/EA2+XPWU2
         Pr6KbnSzAuRTUG8rPDRy6KKAN6EC4Lc+pmY0Tq7uZ6tr3x3ayyowc6pLDlIdW2An2Mpj
         YSaP2UDQnDxSuewBylwlO8qV5dZ8BcteRK/w+c64UNNXWc/MksbijTN36CAE5PsBXjnS
         BOww==
X-Gm-Message-State: AAQBX9cl6t5SFkKJ+dzFvJNBU74BL+H9wGS9s6dKN775AJfGIuaRMMz1
        pgijhmruNmoZAztIg5tD2S1Huzz/7yfBzvHdtyVM
X-Google-Smtp-Source: AKy350YGpKFShus1wXg4P7JDpOEQwCA2ZUIAFxOOzluNG03DhrMlLa19ZC7t5ZHiN0J6rZ9Xc6wbx1W+NEq2mwRq1zY=
X-Received: by 2002:a25:d702:0:b0:b68:7a4a:5258 with SMTP id
 o2-20020a25d702000000b00b687a4a5258mr377571ybg.3.1681254488697; Tue, 11 Apr
 2023 16:08:08 -0700 (PDT)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-8-git-send-email-wufan@linux.microsoft.com>
 <3723852.kQq0lBPeGt@x2> <CAHC9VhRqMrTuvVtwzJoK2U=6O1QuaQ8ceA6+qm=6ib0TOUEeSw@mail.gmail.com>
 <20230316225340.GB22567@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230316225340.GB22567@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 11 Apr 2023 19:07:57 -0400
Message-ID: <CAHC9VhQxxrDnzJmUitMid3fk-VwNRU3NWoqjpj1=rhrtpoE=7w@mail.gmail.com>
Subject: Re: [RFC PATCH v9 07/16] uapi|audit|ipe: add ipe auditing support
To:     Fan Wu <wufan@linux.microsoft.com>
Cc:     Steve Grubb <sgrubb@redhat.com>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com,
        linux-audit@redhat.com, dm-devel@redhat.com,
        linux-doc@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>,
        roberto.sassu@huawei.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 16, 2023 at 6:53=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
> On Thu, Mar 02, 2023 at 02:05:33PM -0500, Paul Moore wrote:
> > On Tue, Jan 31, 2023 at 12:11???PM Steve Grubb <sgrubb@redhat.com> wrot=
e:
> > >
> > > Hello,
> > >
> > > On Monday, January 30, 2023 5:57:22 PM EST Fan Wu wrote:
> > > > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > > >
> > > > Users of IPE require a way to identify when and why an operation fa=
ils,
> > > > allowing them to both respond to violations of policy and be notifi=
ed
> > > > of potentially malicious actions on their systens with respect to I=
PE
> > > > itself.
> > > >
> > > > The new 1420 audit, AUDIT_IPE_ACCESS indicates the result of a poli=
cy
> > > > evaulation of a resource. The other two events, AUDIT_MAC_POLICY_LO=
AD,
> > > > and AUDIT_MAC_CONFIG_CHANGE represent a new policy was loaded into =
the
> > > > kernel and the currently active policy changed, respectively.
> > >
> > > Typically when you reuse an existing record type, it is expected to m=
aintain
> > > the same fields in the same order. Also, it is expect that fields tha=
t are
> > > common across diferent records have the same meaning. To aid in this,=
 we have
> > > a field dictionary here:
> > >
> > > https://github.com/linux-audit/audit-documentation/blob/main/specs/fi=
elds/
> > > field-dictionary.csv
> > >
> > > For example, dev is expected to be 2 hex numbers separated by a colon=
 which
> > > are the device major and minor numbers. But down a couple lines from =
here, we
> > > find dev=3D"tmpfs". But isn't that a filesystem type?
> >
> > What Steve said.
> >
> > I'll also add an administrative note, we just moved upstream Linux
> > audit development to a new mailing list, audit@vger.kernel.org, please
> > use that in future patch submissions.  As a positive, it's a fully
> > open list so you won't run into moderation delays/notifications/etc.
> >
> Thanks for the info, I will update the address.
>
> > > > This patch also adds support for success auditing, allowing users t=
o
> > > > identify how a resource passed policy. It is recommended to use thi=
s
> > > > option with caution, as it is quite noisy.
> > > >
> > > > This patch adds the following audit records:
> > > >
> > > >   audit: AUDIT1420 path=3D"/tmp/tmpwxmam366/deny/bin/hello" dev=3D"=
tmpfs"
> > > >     ino=3D72 rule=3D"DEFAULT op=3DEXECUTE action=3DDENY"
> > >
> > > Do we really need to log the whole rule?
> >
> > Fan, would it be reasonable to list the properties which caused the
> > access denial?  That seems like it might be more helpful than the
> > specific rule, or am I missing something?
>
> Audit the whole rule can let the user find the reason of a policy decisio=
n.
> We need the whole rule because an allow/block is not caused by a specific
> property, but the combination of all property conditions in a rule.

Okay, that's a reasonable argument for logging the rule along with the
decision.  I think it helps that the IPE policy rules are not
particularly long.

> We could also add a verbose switch such that we only audit
> the whole rule when a user turned the verbose switch on.

I'm not sure that's necessary, and honestly it might be annoying as we
would still need to output a 'rule=3D"?"' field in the audit record as
it is considered good practice to not have fields magically appear and
disappear from the record format.  However, if there are concerns
about record sizes, that could be a potential mitigation.

--=20
paul-moore.com
