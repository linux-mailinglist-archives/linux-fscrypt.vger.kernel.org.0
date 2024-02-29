Return-Path: <linux-fscrypt+bounces-202-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E3F086BD7B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 01:58:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 928961C23C62
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 00:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5168C4437C;
	Thu, 29 Feb 2024 00:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="hbe63QnP"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5339533CF5;
	Thu, 29 Feb 2024 00:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709168130; cv=none; b=o4aJIRsmnOVNMXE2BBo603s0A4EcT29ljmxbAYAPNDfM4UfLnT+viWOzDfuTlkCqsGmEGlyJb5tShqPJKJu5K2dr2cgjD62om9u8aTzaZm8DuuPWMMGNt0aRvgL5raxti2hd7FsJbxUETBsi8brBvwLejsAjmSOhABGsS6NWqO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709168130; c=relaxed/simple;
	bh=e1jzAqG7/61YBtH1lWb0arD0ItvvcPp+ysGVrTEC5tg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=CxvX9JsR/DcLX503r1rE86E3aZvvztrivOTnVR1L/ja7OOF+1BhLW/Blw0PFqx05DurB6FdccRw6QyUYwKgqIkNNbAfHBuXInChM5szz8RMrdsYVo4OcUWxJpoooWigGo0dScJef/Xtb+1tHsyhSNNDcKY1kYHMqikOf0iVA/0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=hbe63QnP; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id E018D20B74D1; Wed, 28 Feb 2024 16:55:18 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E018D20B74D1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1709168118;
	bh=jyGlncTOe69uZZ+jmG2Bjgx5//H9EAlNOmuMOusRalE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbe63QnPeo8u+6TjyO17mLFfOeVZAf78+6sSWWcALSxU7vCpcPWjQf/ehESzZfaHa
	 Ard0RkifvcmYr7jQoDHbVYdZdn20A+A115PnishGoRkTAUm0o2d3Xr5Wjrt4oXiqC8
	 8q2Cec392PZAroYz6lMtN+OLUphpcdPDqIvIO4B4=
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net,
	zohar@linux.ibm.com,
	jmorris@namei.org,
	serge@hallyn.com,
	tytso@mit.edu,
	ebiggers@kernel.org,
	axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	eparis@redhat.com,
	paul@paul-moore.com
Cc: linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	audit@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Fan Wu <wufan@linux.microsoft.com>
Subject: [RFC PATCH v13 09/20] uapi|audit|ipe: add ipe auditing support
Date: Wed, 28 Feb 2024 16:54:51 -0800
Message-Id: <1709168102-7677-10-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
References: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>

From: Deven Bowers <deven.desai@linux.microsoft.com>

Users of IPE require a way to identify when and why an operation fails,
allowing them to both respond to violations of policy and be notified
of potentially malicious actions on their systems with respect to IPE
itself.

This patch introduces 3 new audit events.

AUDIT_IPE_ACCESS(1420) indicates the result of an IPE policy evaluation
of a resource.
AUDIT_IPE_CONFIG_CHANGE(1421) indicates the current active IPE policy
has been changed to another loaded policy.
AUDIT_IPE_POLICY_LOAD(1422) indicates a new IPE policy has been loaded
into the kernel.

This patch also adds support for success auditing, allowing users to
identify why an allow decision was made for a resource. However, it is
recommended to use this option with caution, as it is quite noisy.

Here are some examples of the new audit record types:

AUDIT_IPE_ACCESS(1420):

    audit: AUDIT1420 ipe_op=EXECUTE ipe_hook=BPRM_CHECK enforcing=1
      pid=297 comm="sh" path="/root/vol/bin/hello" dev="tmpfs"
      ino=3897 rule="op=EXECUTE boot_verified=TRUE action=ALLOW"

    audit: AUDIT1420 ipe_op=EXECUTE ipe_hook=BPRM_CHECK enforcing=1
      pid=299 comm="sh" path="/mnt/ipe/bin/hello" dev="dm-0"
      ino=2 rule="DEFAULT action=DENY"

    audit: AUDIT1420 ipe_op=EXECUTE ipe_hook=BPRM_CHECK enforcing=1
     pid=300 path="/tmp/tmpdp2h1lub/deny/bin/hello" dev="tmpfs"
      ino=131 rule="DEFAULT action=DENY"

The above three records were generated when the active IPE policy only
allows binaries from the initramfs to run. The three identical `hello`
binary were placed at different locations, only the first hello from
the rootfs(initramfs) was allowed.

Field ipe_op followed by the IPE operation name associated with the log.

Field ipe_hook followed by the name of the LSM hook that triggered the IPE
event.

Field enforcing followed by the enforcement state of IPE. (it will be
introduced in the next commit)

Field pid followed by the pid of the process that triggered the IPE
event.

Field comm followed by the command line program name of the process that
triggered the IPE event.

Field path followed by the file's path name.

Field dev followed by the device name as found in /dev where the file is
from.
Note that for device mappers it will use the name `dm-X` instead of
the name in /dev/mapper.
For a file in a temp file system, which is not from a device, it will use
`tmpfs` for the field.
The implementation of this part is following another existing use case
LSM_AUDIT_DATA_INODE in security/lsm_audit.c

Field ino followed by the file's inode number.

Field rule followed by the IPE rule made the access decision. The whole
rule must be audited because the decision is based on the combination of
all property conditions in the rule.

Along with the syscall audit event, user can know why a blocked
happened. For example:

    audit: AUDIT1420 ipe_op=EXECUTE ipe_hook=BPRM_CHECK enforcing=1
      pid=2138 comm="bash" path="/mnt/ipe/bin/hello" dev="dm-0"
      ino=2 rule="DEFAULT action=DENY"
    audit[1956]: SYSCALL arch=c000003e syscall=59
      success=no exit=-13 a0=556790138df0 a1=556790135390 a2=5567901338b0
      a3=ab2a41a67f4f1f4e items=1 ppid=147 pid=1956 auid=4294967295 uid=0
      gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0
      ses=4294967295 comm="bash" exe="/usr/bin/bash" key=(null)

The above two records showed bash used execve to run "hello" and got
blocked by IPE. Note that the IPE records are always prior to a SYSCALL
record.

AUDIT_IPE_CONFIG_CHANGE(1421):

    audit: AUDIT1421
      old_active_pol_name="Allow_All" old_active_pol_version=0.0.0
      old_policy_digest=sha256:E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649
      new_active_pol_name="boot_verified" new_active_pol_version=0.0.0
      new_policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F
      auid=4294967295 ses=4294967295 lsm=ipe res=1

The above record showed the current IPE active policy switch from
`Allow_All` to `boot_verified` along with the version and the hash
digest of the two policies. Note IPE can only have one policy active
at a time, all access decision evaluation is based on the current active
policy.
The normal procedure to deploy a policy is loading the policy to deploy
into the kernel first, then switch the active policy to it.

AUDIT_IPE_POLICY_LOAD(1422):

    audit: AUDIT1422 policy_name="boot_verified" policy_version=0.0.0
      policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F2676
      auid=4294967295 ses=4294967295 lsm=ipe res=1

The above record showed a new policy has been loaded into the kernel
with the policy name, policy version and policy hash.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v2:
  + Split evaluation loop, access control hooks,
    and evaluation loop from policy parser and userspace
    interface to pass mailing list character limit

v3:
  + Move ipe_load_properties to patch 04.
  + Remove useless 0-initializations
  + Prefix extern variables with ipe_
  + Remove kernel module parameters, as these are
    exposed through sysctls.
  + Add more prose to the IPE base config option
    help text.
  + Use GFP_KERNEL for audit_log_start.
  + Remove unnecessary caching system.
  + Remove comments from headers
  + Use rcu_access_pointer for rcu-pointer null check
  + Remove usage of reqprot; use prot only.
  + Move policy load and activation audit event to 03/12

v4:
  + Remove sysctls in favor of securityfs nodes
  + Re-add kernel module parameters, as these are now
    exposed through securityfs.
  + Refactor property audit loop to a separate function.

v5:
  + fix minor grammatical errors
  + do not group rule by curly-brace in audit record,
    reconstruct the exact rule.

v6:
  + No changes

v7:
  + Further split lsm creation, the audit system, the evaluation loop,
    and access control hooks into separate patches.
  + Further split audit system patch into two separate patches; one
    for include/uapi, and the usage of the new defines.
  + Split out the permissive functionality into another separate patch,
    for easier review.
  + Correct misuse of audit_log_n_untrusted string to audit_log_format
  + Use get_task_comm instead of comm directly.
  + Quote certain audit values
  + Remove unnecessary help text on choice options - these were
    previously indented at the wrong level
  + Correct a stale string constant (ctx_ns_enforce to ctx_enforce)

v8:

  + Change dependency for CONFIG_AUDIT to CONFIG_AUDITSYSCALL
  + Drop ctx_* prefix
  + Reuse, where appropriate, the audit fields from the field
    dictionary. This transforms:
      ctx_pathname  -> path
      ctx_ino       -> ino
      ctx_dev       -> dev

  + Add audit records and event examples to commit description.
  + Remove new_audit_ctx, replace with audit_log_start. All data that
    would provided by new_audit_ctx is already present in the syscall
    audit record, that is always emitted on these actions. The audit
    records should be correlated as such.
  + Change audit types:
    + AUDIT_TRUST_RESULT                -> AUDIT_IPE_ACCESS
      +  This prevents overloading of the AVC type.
    + AUDIT_TRUST_POLICY_ACTIVATE       -> AUDIT_MAC_CONFIG_CHANGE
    + AUDIT_TRUST_POLICY_LOAD           -> AUDIT_MAC_POLICY_LOAD
      + There were no significant difference in meaning between
        these types.

  + Remove enforcing parameter passed from the context structure
    for AUDIT_IPE_ACCESS.
    +  This field can be inferred from the SYSCALL audit event,
       based on the success field.

  + Remove all fields already captured in the syscall record. "hook",
    an IPE specific field, can be determined via the syscall field in
    the syscall record itself, so it has been removed.
      + ino, path, and dev in IPE's record refer to the subject of the
        syscall, while the syscall record refers to the calling process.

  + remove IPE prefix from policy load/policy activation events
  + fix a bug wherein a policy change audit record was not fired when
    updating a policy

v9:
  + Merge the AUDIT_IPE_ACCESS definition with the audit support commit
  + Change the audit format of policy load and switch
  + Remove the ipe audit kernel switch

v10:
  + Create AUDIT_IPE_CONFIG_CHANGE and AUDIT_IPE_POLICY_LOAD
  + Change field names per upstream feedback

v11:
  + Fix style issues

v12:
  + Add ipe_op, ipe_hook, and enforcing fields to AUDIT_IPE_ACCESS

v13:
  + Remove dependency on CONFIG_BLK_DEV_INITRD
  + Add field placeholders for anonymous files
---
 include/uapi/linux/audit.h |   3 +
 security/ipe/Kconfig       |   2 +-
 security/ipe/Makefile      |   1 +
 security/ipe/audit.c       | 214 +++++++++++++++++++++++++++++++++++++
 security/ipe/audit.h       |  18 ++++
 security/ipe/eval.c        |  44 ++++++--
 security/ipe/eval.h        |  13 ++-
 security/ipe/fs.c          |  70 ++++++++++++
 security/ipe/hooks.c       |  10 +-
 security/ipe/hooks.h       |  11 ++
 security/ipe/policy.c      |   5 +
 11 files changed, 374 insertions(+), 17 deletions(-)
 create mode 100644 security/ipe/audit.c
 create mode 100644 security/ipe/audit.h

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index d676ed2b246e..75e21a135483 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -143,6 +143,9 @@
 #define AUDIT_MAC_UNLBL_STCDEL	1417	/* NetLabel: del a static label */
 #define AUDIT_MAC_CALIPSO_ADD	1418	/* NetLabel: add CALIPSO DOI entry */
 #define AUDIT_MAC_CALIPSO_DEL	1419	/* NetLabel: del CALIPSO DOI entry */
+#define AUDIT_IPE_ACCESS	1420	/* IPE denial or grant */
+#define AUDIT_IPE_CONFIG_CHANGE	1421	/* IPE config change */
+#define AUDIT_IPE_POLICY_LOAD	1422	/* IPE policy load */
 
 #define AUDIT_FIRST_KERN_ANOM_MSG   1700
 #define AUDIT_LAST_KERN_ANOM_MSG    1799
diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
index e4875fb04883..ac4d558e69d5 100644
--- a/security/ipe/Kconfig
+++ b/security/ipe/Kconfig
@@ -5,7 +5,7 @@
 
 menuconfig SECURITY_IPE
 	bool "Integrity Policy Enforcement (IPE)"
-	depends on SECURITY && SECURITYFS
+	depends on SECURITY && SECURITYFS && AUDIT && AUDITSYSCALL
 	select PKCS7_MESSAGE_PARSER
 	select SYSTEM_DATA_VERIFICATION
 	help
diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index cfbed03a8885..2279eaa3cea3 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_SECURITY_IPE) += \
 	policy.o \
 	policy_fs.o \
 	policy_parser.o \
+	audit.o \
diff --git a/security/ipe/audit.c b/security/ipe/audit.c
new file mode 100644
index 000000000000..f167fdc87986
--- /dev/null
+++ b/security/ipe/audit.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include <linux/slab.h>
+#include <linux/audit.h>
+#include <linux/types.h>
+#include <crypto/hash.h>
+
+#include "ipe.h"
+#include "eval.h"
+#include "hooks.h"
+#include "policy.h"
+#include "audit.h"
+
+#define ACTSTR(x) ((x) == IPE_ACTION_ALLOW ? "ALLOW" : "DENY")
+
+#define IPE_AUDIT_HASH_ALG "sha256"
+
+#define AUDIT_POLICY_LOAD_FMT "policy_name=\"%s\" policy_version=%hu.%hu.%hu "\
+			      "policy_digest=" IPE_AUDIT_HASH_ALG ":"
+#define AUDIT_OLD_ACTIVE_POLICY_FMT "old_active_pol_name=\"%s\" "\
+				    "old_active_pol_version=%hu.%hu.%hu "\
+				    "old_policy_digest=" IPE_AUDIT_HASH_ALG ":"
+#define AUDIT_NEW_ACTIVE_POLICY_FMT "new_active_pol_name=\"%s\" "\
+				    "new_active_pol_version=%hu.%hu.%hu "\
+				    "new_policy_digest=" IPE_AUDIT_HASH_ALG ":"
+
+static const char *const audit_op_names[__IPE_OP_MAX + 1] = {
+	"EXECUTE",
+	"FIRMWARE",
+	"KMODULE",
+	"KEXEC_IMAGE",
+	"KEXEC_INITRAMFS",
+	"POLICY",
+	"X509_CERT",
+	"UNKNOWN",
+};
+
+static const char *const audit_hook_names[__IPE_HOOK_MAX] = {
+	"BPRM_CHECK",
+	"MMAP",
+	"MPROTECT",
+	"KERNEL_READ",
+	"KERNEL_LOAD",
+};
+
+static const char *const audit_prop_names[__IPE_PROP_MAX] = {
+	"boot_verified=FALSE",
+	"boot_verified=TRUE",
+};
+
+/**
+ * audit_rule - audit an IPE policy rule approximation.
+ * @ab: Supplies a pointer to the audit_buffer to append to.
+ * @r: Supplies a pointer to the ipe_rule to approximate a string form for.
+ */
+static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
+{
+	const struct ipe_prop *ptr;
+
+	audit_log_format(ab, " rule=\"%s ", audit_op_names[r->op]);
+
+	list_for_each_entry(ptr, &r->props, next)
+		audit_log_format(ab, "%s ", audit_prop_names[ptr->type]);
+
+	audit_log_format(ab, "action=%s\"", ACTSTR(r->action));
+}
+
+/**
+ * ipe_audit_match - audit a match for IPE policy.
+ * @ctx: Supplies a pointer to the evaluation context that was used in the
+ *	 evaluation.
+ * @match_type: Supplies the scope of the match: rule, operation default,
+ *		global default.
+ * @act: Supplies the IPE's evaluation decision, deny or allow.
+ * @r: Supplies a pointer to the rule that was matched, if possible.
+ */
+void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
+		     enum ipe_match match_type,
+		     enum ipe_action_type act, const struct ipe_rule *const r)
+{
+	struct inode *inode;
+	struct audit_buffer *ab;
+	const char *op = audit_op_names[ctx->op];
+	char comm[sizeof(current->comm)];
+
+	if (act != IPE_ACTION_DENY && !READ_ONCE(success_audit))
+		return;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_IPE_ACCESS);
+	if (!ab)
+		return;
+
+	audit_log_format(ab, "ipe_op=%s ipe_hook=%s pid=%d comm=",
+			 op, audit_hook_names[ctx->hook],
+			 task_tgid_nr(current));
+	audit_log_untrustedstring(ab, get_task_comm(comm, current));
+
+	if (ctx->file) {
+		audit_log_d_path(ab, " path=", &ctx->file->f_path);
+		inode = file_inode(ctx->file);
+		if (inode) {
+			audit_log_format(ab, " dev=");
+			audit_log_untrustedstring(ab, inode->i_sb->s_id);
+			audit_log_format(ab, " ino=%lu", inode->i_ino);
+		} else {
+			audit_log_format(ab, " dev=? ino=?");
+		}
+	} else {
+		audit_log_format(ab, " path=? dev=? ino=?");
+	}
+
+	if (match_type == IPE_MATCH_RULE)
+		audit_rule(ab, r);
+	else if (match_type == IPE_MATCH_TABLE)
+		audit_log_format(ab, " rule=\"DEFAULT op=%s action=%s\"", op,
+				 ACTSTR(act));
+	else
+		audit_log_format(ab, " rule=\"DEFAULT action=%s\"",
+				 ACTSTR(act));
+
+	audit_log_end(ab);
+}
+
+/**
+ * audit_policy - Audit a policy's name, version and thumbprint to @ab.
+ * @ab: Supplies a pointer to the audit buffer to append to.
+ * @audit_format: Supplies a pointer to the audit format string
+ * @p: Supplies a pointer to the policy to audit.
+ */
+static void audit_policy(struct audit_buffer *ab,
+			 const char *audit_format,
+			 const struct ipe_policy *const p)
+{
+	u8 *digest = NULL;
+	struct crypto_shash *tfm;
+	SHASH_DESC_ON_STACK(desc, tfm);
+
+	tfm = crypto_alloc_shash(IPE_AUDIT_HASH_ALG, 0, 0);
+	if (IS_ERR(tfm))
+		return;
+
+	desc->tfm = tfm;
+
+	digest = kzalloc(crypto_shash_digestsize(tfm), GFP_KERNEL);
+	if (!digest)
+		goto out;
+
+	if (crypto_shash_init(desc))
+		goto out;
+
+	if (crypto_shash_update(desc, p->pkcs7, p->pkcs7len))
+		goto out;
+
+	if (crypto_shash_final(desc, digest))
+		goto out;
+
+	audit_log_format(ab, audit_format, p->parsed->name,
+			 p->parsed->version.major, p->parsed->version.minor,
+			 p->parsed->version.rev);
+	audit_log_n_hex(ab, digest, crypto_shash_digestsize(tfm));
+
+out:
+	kfree(digest);
+	crypto_free_shash(tfm);
+}
+
+/**
+ * ipe_audit_policy_activation - Audit a policy being made the active policy.
+ * @op: Supplies a pointer to the previously activated policy to audit.
+ * @np: Supplies a pointer to the newly activated policy to audit.
+ */
+void ipe_audit_policy_activation(const struct ipe_policy *const op,
+				 const struct ipe_policy *const np)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL,
+			     AUDIT_IPE_CONFIG_CHANGE);
+	if (!ab)
+		return;
+
+	audit_policy(ab, AUDIT_OLD_ACTIVE_POLICY_FMT, op);
+	audit_log_format(ab, " ");
+	audit_policy(ab, AUDIT_NEW_ACTIVE_POLICY_FMT, np);
+	audit_log_format(ab, " auid=%u ses=%u lsm=ipe res=1",
+			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
+			 audit_get_sessionid(current));
+
+	audit_log_end(ab);
+}
+
+/**
+ * ipe_audit_policy_load - Audit a policy being loaded into the kernel.
+ * @p: Supplies a pointer to the policy to audit.
+ */
+void ipe_audit_policy_load(const struct ipe_policy *const p)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL,
+			     AUDIT_IPE_POLICY_LOAD);
+	if (!ab)
+		return;
+
+	audit_policy(ab, AUDIT_POLICY_LOAD_FMT, p);
+	audit_log_format(ab, " auid=%u ses=%u lsm=ipe res=1",
+			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
+			 audit_get_sessionid(current));
+
+	audit_log_end(ab);
+}
diff --git a/security/ipe/audit.h b/security/ipe/audit.h
new file mode 100644
index 000000000000..0ff5a06808de
--- /dev/null
+++ b/security/ipe/audit.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef _IPE_AUDIT_H
+#define _IPE_AUDIT_H
+
+#include "policy.h"
+
+void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
+		     enum ipe_match match_type,
+		     enum ipe_action_type act, const struct ipe_rule *const r);
+void ipe_audit_policy_load(const struct ipe_policy *const p);
+void ipe_audit_policy_activation(const struct ipe_policy *const op,
+				 const struct ipe_policy *const np);
+
+#endif /* _IPE_AUDIT_H */
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index bef204decbbf..274f7346ef42 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -9,12 +9,15 @@
 #include <linux/file.h>
 #include <linux/sched.h>
 #include <linux/rcupdate.h>
+#include <linux/moduleparam.h>
 
 #include "ipe.h"
 #include "eval.h"
 #include "policy.h"
+#include "audit.h"
 
 struct ipe_policy __rcu *ipe_active_policy;
+bool success_audit;
 
 #define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
 
@@ -33,13 +36,16 @@ static void build_ipe_sb_ctx(struct ipe_eval_ctx *ctx, const struct file *const
  * @ctx: Supplies a pointer to the context to be populated.
  * @file: Supplies a pointer to the file to associated with the evaluation.
  * @op: Supplies the IPE policy operation associated with the evaluation.
+ * @hook: Supplies the LSM hook associated with the evaluation.
  */
 void build_eval_ctx(struct ipe_eval_ctx *ctx,
 		    const struct file *file,
-		    enum ipe_op_type op)
+		    enum ipe_op_type op,
+		    enum ipe_hook_type hook)
 {
 	ctx->file = file;
 	ctx->op = op;
+	ctx->hook = hook;
 
 	if (file)
 		build_ipe_sb_ctx(ctx, file);
@@ -95,6 +101,7 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
 {
 	bool match = false;
 	enum ipe_action_type action;
+	enum ipe_match match_type;
 	struct ipe_policy *pol = NULL;
 	const struct ipe_rule *rule = NULL;
 	const struct ipe_op_table *rules = NULL;
@@ -109,14 +116,15 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
 	}
 
 	if (ctx->op == IPE_OP_INVALID) {
-		if (pol->parsed->global_default_action == IPE_ACTION_DENY) {
-			rcu_read_unlock();
-			return -EACCES;
-		}
-		if (pol->parsed->global_default_action == IPE_ACTION_INVALID)
+		if (pol->parsed->global_default_action == IPE_ACTION_INVALID) {
 			WARN(1, "no default rule set for unknown op, ALLOW it");
+			action = IPE_ACTION_ALLOW;
+		} else {
+			action = pol->parsed->global_default_action;
+		}
 		rcu_read_unlock();
-		return 0;
+		match_type = IPE_MATCH_GLOBAL;
+		goto eval;
 	}
 
 	rules = &pol->parsed->rules[ctx->op];
@@ -134,16 +142,32 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
 			break;
 	}
 
-	if (match)
+	if (match) {
 		action = rule->action;
-	else if (rules->default_action != IPE_ACTION_INVALID)
+		match_type = IPE_MATCH_RULE;
+	} else if (rules->default_action != IPE_ACTION_INVALID) {
 		action = rules->default_action;
-	else
+		match_type = IPE_MATCH_TABLE;
+	} else {
 		action = pol->parsed->global_default_action;
+		match_type = IPE_MATCH_GLOBAL;
+	}
 
 	rcu_read_unlock();
+eval:
+	ipe_audit_match(ctx, match_type, action, rule);
+
 	if (action == IPE_ACTION_DENY)
 		return -EACCES;
 
 	return 0;
 }
+
+/* Set the right module name */
+#ifdef KBUILD_MODNAME
+#undef KBUILD_MODNAME
+#define KBUILD_MODNAME "ipe"
+#endif
+
+module_param(success_audit, bool, 0400);
+MODULE_PARM_DESC(success_audit, "Start IPE with success auditing enabled");
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index 884821494525..4631b236358e 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -10,10 +10,12 @@
 #include <linux/types.h>
 
 #include "policy.h"
+#include "hooks.h"
 
 #define IPE_EVAL_CTX_INIT ((struct ipe_eval_ctx){ 0 })
 
 extern struct ipe_policy __rcu *ipe_active_policy;
+extern bool success_audit;
 
 struct ipe_superblock {
 	bool initramfs;
@@ -21,12 +23,21 @@ struct ipe_superblock {
 
 struct ipe_eval_ctx {
 	enum ipe_op_type op;
+	enum ipe_hook_type hook;
 
 	const struct file *file;
 	bool initramfs;
 };
 
-void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file, enum ipe_op_type op);
+enum ipe_match {
+	IPE_MATCH_RULE = 0,
+	IPE_MATCH_TABLE,
+	IPE_MATCH_GLOBAL,
+	__IPE_MATCH_MAX
+};
+
+void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file,
+		    enum ipe_op_type op, enum ipe_hook_type hook);
 int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx);
 
 #endif /* _IPE_EVAL_H */
diff --git a/security/ipe/fs.c b/security/ipe/fs.c
index 4949296caeb5..95407997cf0c 100644
--- a/security/ipe/fs.c
+++ b/security/ipe/fs.c
@@ -8,11 +8,64 @@
 
 #include "ipe.h"
 #include "fs.h"
+#include "eval.h"
 #include "policy.h"
+#include "audit.h"
 
 static struct dentry *np __ro_after_init;
 static struct dentry *root __ro_after_init;
 struct dentry *policy_root __ro_after_init;
+static struct dentry *audit_node __ro_after_init;
+
+/**
+ * setaudit - Write handler for the securityfs node, "ipe/success_audit"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall.
+ * @len: Supplies the length of @data.
+ * @offset: unused.
+ *
+ * Return:
+ * * >0	- Success, Length of buffer written
+ * * <0	- Error
+ */
+static ssize_t setaudit(struct file *f, const char __user *data,
+			size_t len, loff_t *offset)
+{
+	int rc = 0;
+	bool value;
+
+	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
+		return -EPERM;
+
+	rc = kstrtobool_from_user(data, len, &value);
+	if (rc)
+		return rc;
+
+	WRITE_ONCE(success_audit, value);
+
+	return len;
+}
+
+/**
+ * getaudit - Read handler for the securityfs node, "ipe/success_audit"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the read syscall.
+ * @len: Supplies the length of @data.
+ * @offset: unused.
+ *
+ * Return:
+ * * >0	- Success, Length of buffer written
+ * * <0	- Error
+ */
+static ssize_t getaudit(struct file *f, char __user *data,
+			size_t len, loff_t *offset)
+{
+	const char *result;
+
+	result = ((READ_ONCE(success_audit)) ? "1" : "0");
+
+	return simple_read_from_buffer(data, len, offset, result, 1);
+}
 
 /**
  * new_policy - Write handler for the securityfs node, "ipe/new_policy".
@@ -46,6 +99,10 @@ static ssize_t new_policy(struct file *f, const char __user *data,
 	}
 
 	rc = ipe_new_policyfs_node(p);
+	if (rc)
+		goto out;
+
+	ipe_audit_policy_load(p);
 
 out:
 	if (rc < 0)
@@ -58,6 +115,11 @@ static const struct file_operations np_fops = {
 	.write = new_policy,
 };
 
+static const struct file_operations audit_fops = {
+	.write = setaudit,
+	.read = getaudit,
+};
+
 /**
  * ipe_init_securityfs - Initialize IPE's securityfs tree at fsinit.
  *
@@ -78,6 +140,13 @@ static int __init ipe_init_securityfs(void)
 		goto err;
 	}
 
+	audit_node = securityfs_create_file("success_audit", 0600, root,
+					    NULL, &audit_fops);
+	if (IS_ERR(audit_node)) {
+		rc = PTR_ERR(audit_node);
+		goto err;
+	}
+
 	policy_root = securityfs_create_dir("policies", root);
 	if (IS_ERR(policy_root)) {
 		rc = PTR_ERR(policy_root);
@@ -94,6 +163,7 @@ static int __init ipe_init_securityfs(void)
 err:
 	securityfs_remove(np);
 	securityfs_remove(policy_root);
+	securityfs_remove(audit_node);
 	securityfs_remove(root);
 	return rc;
 }
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index 23cf070438fa..6bcc7908ed13 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -28,7 +28,7 @@ int ipe_bprm_check_security(struct linux_binprm *bprm)
 {
 	struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
 
-	build_eval_ctx(&ctx, bprm->file, IPE_OP_EXEC);
+	build_eval_ctx(&ctx, bprm->file, IPE_OP_EXEC, IPE_HOOK_BPRM_CHECK);
 	return ipe_evaluate_event(&ctx);
 }
 
@@ -53,7 +53,7 @@ int ipe_mmap_file(struct file *f, unsigned long reqprot __always_unused,
 	struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
 
 	if (prot & PROT_EXEC) {
-		build_eval_ctx(&ctx, f, IPE_OP_EXEC);
+		build_eval_ctx(&ctx, f, IPE_OP_EXEC, IPE_HOOK_MMAP);
 		return ipe_evaluate_event(&ctx);
 	}
 
@@ -85,7 +85,7 @@ int ipe_file_mprotect(struct vm_area_struct *vma,
 		return 0;
 
 	if (prot & PROT_EXEC) {
-		build_eval_ctx(&ctx, vma->vm_file, IPE_OP_EXEC);
+		build_eval_ctx(&ctx, vma->vm_file, IPE_OP_EXEC, IPE_HOOK_MPROTECT);
 		return ipe_evaluate_event(&ctx);
 	}
 
@@ -135,7 +135,7 @@ int ipe_kernel_read_file(struct file *file, enum kernel_read_file_id id,
 		WARN(1, "no rule setup for kernel_read_file enum %d", id);
 	}
 
-	build_eval_ctx(&ctx, file, op);
+	build_eval_ctx(&ctx, file, op, IPE_HOOK_KERNEL_READ);
 	return ipe_evaluate_event(&ctx);
 }
 
@@ -179,7 +179,7 @@ int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents)
 		WARN(1, "no rule setup for kernel_load_data enum %d", id);
 	}
 
-	build_eval_ctx(&ctx, NULL, op);
+	build_eval_ctx(&ctx, NULL, op, IPE_HOOK_KERNEL_LOAD);
 	return ipe_evaluate_event(&ctx);
 }
 
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index 21f49cdc2fcd..b92c1d78e253 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -9,6 +9,17 @@
 #include <linux/binfmts.h>
 #include <linux/security.h>
 
+enum ipe_hook_type {
+	IPE_HOOK_BPRM_CHECK = 0,
+	IPE_HOOK_MMAP,
+	IPE_HOOK_MPROTECT,
+	IPE_HOOK_KERNEL_READ,
+	IPE_HOOK_KERNEL_LOAD,
+	__IPE_HOOK_MAX
+};
+
+#define IPE_HOOK_INVALID __IPE_HOOK_MAX
+
 int ipe_bprm_check_security(struct linux_binprm *bprm);
 
 int ipe_mmap_file(struct file *f, unsigned long reqprot, unsigned long prot,
diff --git a/security/ipe/policy.c b/security/ipe/policy.c
index 0ba2b9c62c23..8b9878f2375b 100644
--- a/security/ipe/policy.c
+++ b/security/ipe/policy.c
@@ -11,6 +11,7 @@
 #include "fs.h"
 #include "policy.h"
 #include "policy_parser.h"
+#include "audit.h"
 
 /* lock for synchronizing writers across ipe policy */
 DEFINE_MUTEX(ipe_policy_lock);
@@ -114,6 +115,7 @@ int ipe_update_policy(struct inode *root, const char *text, size_t textlen,
 
 	root->i_private = new;
 	swap(new->policyfs, old->policyfs);
+	ipe_audit_policy_load(new);
 
 	mutex_lock(&ipe_policy_lock);
 	ap = rcu_dereference_protected(ipe_active_policy,
@@ -122,6 +124,7 @@ int ipe_update_policy(struct inode *root, const char *text, size_t textlen,
 		rcu_assign_pointer(ipe_active_policy, new);
 		mutex_unlock(&ipe_policy_lock);
 		synchronize_rcu();
+		ipe_audit_policy_activation(old, new);
 	} else {
 		mutex_unlock(&ipe_policy_lock);
 	}
@@ -220,5 +223,7 @@ int ipe_set_active_pol(const struct ipe_policy *p)
 	mutex_unlock(&ipe_policy_lock);
 	synchronize_rcu();
 
+	ipe_audit_policy_activation(ap, p);
+
 	return 0;
 }
-- 
2.43.1


