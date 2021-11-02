Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B8A44369C
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Nov 2021 20:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhKBTrn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 2 Nov 2021 15:47:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43094 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230419AbhKBTrm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 2 Nov 2021 15:47:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635882306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PQ8nOSDyThuDlZIiMZiN+QTPFuYT+d2aZ2ikFkCkMcE=;
        b=Qbl0jfWtiCEk76R0WzU1VJ9Ru1fDMrbe8xTORoVPpcRVE0itskxCIMfHnP3GfI6Fb0IK7K
        zHdTpACZvN8VtXGlB8ucVItcgPuxbXjtE0FP8she3QM6uzt0/sh56uwQgbxschYKr3m5Y0
        lFzdSmGhqsHepDLjum9ilxIPYNzCZAo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-y6Rqj8xoM72y-c7aEUSFdA-1; Tue, 02 Nov 2021 15:45:03 -0400
X-MC-Unique: y6Rqj8xoM72y-c7aEUSFdA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 958001808320;
        Tue,  2 Nov 2021 19:45:00 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.9.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20627226E9;
        Tue,  2 Nov 2021 19:44:31 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu,
        paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org,
        serge@hallyn.com, linux-audit@redhat.com,
        Deven Bowers <deven.desai@linux.microsoft.com>
Cc:     linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        jannh@google.com, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [RFC PATCH v7 07/16] ipe: add auditing support
Date:   Tue, 02 Nov 2021 15:44:30 -0400
Message-ID: <1898302.usQuhbGJ8B@x2>
Organization: Red Hat
In-Reply-To: <8802b1ff-3028-642a-22c5-bc4896450a60@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com> <2159283.iZASKD2KPV@x2> <8802b1ff-3028-642a-22c5-bc4896450a60@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

On Friday, October 15, 2021 3:25:47 PM EDT Deven Bowers wrote:
> On 10/13/2021 1:02 PM, Steve Grubb wrote:
> > On Wednesday, October 13, 2021 3:06:26 PM EDT
> > deven.desai@linux.microsoft.com>=20
> > wrote:
> >> Users of IPE require a way to identify when and why an operation fails,
> >> allowing them to both respond to violations of policy and be notified
> >> of potentially malicious actions on their systens with respect to IPE
> >> itself.
> >=20
> > Would you mind sending examples of audit events so that we can see what
> > the end result is? Some people add them to the commit text. But we still
> > need to see what they look like.
>=20
> Sure, sorry. I=E2=80=99ll add them to the commit description (and the doc=
umentation
> patch at the end) for v8 =E2=80=93 In the interest of asynchronous feedba=
ck, I=E2=80=99ve
> copied the relevant examples:

Thanks for sending these. This helps.

=20
> AUDIT1420 IPE ctx_pid=3D229 ctx_op=3DEXECUTE ctx_hook=3DMMAP ctx_enforce=
=3D0
> ctx_comm=3D"grep" ctx_pathname=3D"/usr/lib/libc-2.23.so"
> ctx_ino=3D532 ctx_dev=3Dvda rule=3D"DEFAULT op=3DEXECUTE action=3DDENY"

Question...why do all of these have a ctx_  prefix? Is it possible to trigg=
er=20
an audit context so that the audit machinery collects all of this stuff in=
=20
it's own way? Which means you could drop everything execept op, hook,=20
enforce, rule, and action.

We also have a field dictionary here:
https://github.com/linux-audit/audit-documentation/blob/main/specs/fields/
field-dictionary.csv

which names the known fields and how they should be formatted. If there is =
a=20
collision where they are something else and cannot be in the same format,=20
then we make a new name and hopefully update the dictionary. For example, i=
f=20
you are collecting a process id, use pid and not ctx_pid so that it matches=
 a=20
known definition.

Also, I don't thnk these events can stand on their own. Who did this action=
?=20
You have the pid, but no uid, auid, or session_id.

Hope this helps...

=2DSteve

=20
> AUDIT1420 IPE ctx_pid=3D229 ctx_op=3DEXECUTE ctx_hook=3DMMAP ctx_enforce=
=3D0
> ctx_comm=3D"grep" ctx_pathname=3D"/usr/lib/libc-2.23.so"
> ctx_ino=3D532 ctx_dev=3Dvda rule=3D"DEFAULT action=3DDENY"
>=20
> AUDIT1420 IPE ctx_pid=3D253 ctx_op=3DEXECUTE ctx_hook=3DMMAP ctx_enforce=
=3D1
> ctx_comm=3D"anon" rule=3D"DEFAULT op=3DEXECUTE action=3DDENY"
>=20
> These three audit records represent various types of results after
> evaluating
> the trust of a resource. The first two differ in the rule that was
> matched in
> IPE's policy, the first being an operation-specific default, the second
> being
> a global default. The third is an example of what is audited when anonymo=
us
> memory is blocked (as there is no way to verify the trust of an anonymous
> page).
>=20
> The remaining three events, AUDIT_TRUST_POLICY_LOAD (1421),
> AUDIT_TRUST_POLICY_ACTIVATE (1422), and AUDIT_TRUST_STATUS (1423) have th=
is
> form:
>=20
> AUDIT1421 IPE policy_name=3D"my-policy" policy_version=3D0.0.0
> <hash_alg_name>=3D<hash>
> AUDIT1422 IPE policy_name=3D"my-policy" policy_version=3D0.0.0
> <hash_alg_name>=3D<hash>
> AUDIT1423 IPE enforce=3D1
>=20
> The 1421 (AUDIT_TRUST_POLICY_LOAD) event represents a new policy was load=
ed
> into the kernel, but not is not marked as the policy to enforce. The
>=20
> The 1422 (AUDIT_TRUST_POLICY_ACTIVATE) event represents a policy that was
> already loaded was made the enforcing policy.
>=20
> The 1423 (AUDIT_TRUST_STATUS) event represents a switch between
> permissive and
> enforce, it is added in 08/16 (the following patch)




